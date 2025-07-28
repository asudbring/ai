@description('The location for all resources.')
param location string = resourceGroup().location

@description('The name prefix for resources.')
param resourcePrefix string = 'hub-spoke'

@description('Username for the Virtual Machine.')
param adminUsername string = 'azureuser'

@description('Type of authentication to use on the Virtual Machine. SSH key is recommended.')
@allowed([
  'sshPublicKey'
  'password'
])
param authenticationType string = 'password'

@description('SSH Key or password for the Virtual Machine. SSH key is recommended.')
@secure()
param adminPasswordOrKey string

// Virtual Networks
resource hubVirtualNetwork 'Microsoft.Network/virtualNetworks@2024-05-01' = {
  name: '${resourcePrefix}-vnet-hub'
  location: location
  properties: {
    addressSpace: {
      addressPrefixes: [
        '10.0.0.0/16'
      ]
    }
    subnets: [
      {
        name: 'AzureFirewallSubnet'
        properties: {
          addressPrefix: '10.0.1.0/26'
          natGateway: {
            id: natGateway.id
          }
        }
      }
      {
        name: 'AzureBastionSubnet'
        properties: {
          addressPrefix: '10.0.2.0/27'
        }
      }
    ]
  }
}

resource spokeVirtualNetwork 'Microsoft.Network/virtualNetworks@2024-05-01' = {
  name: '${resourcePrefix}-vnet-spoke'
  location: location
  properties: {
    addressSpace: {
      addressPrefixes: [
        '10.1.0.0/16'
      ]
    }
    subnets: [
      {
        name: 'subnet-private'
        properties: {
          addressPrefix: '10.1.0.0/24'
          routeTable: {
            id: spokeRouteTable.id
          }
          networkSecurityGroup: {
            id: spokeNetworkSecurityGroup.id
          }
        }
      }
    ]
  }
}

// Virtual Network Peering
resource hubToSpokeePeering 'Microsoft.Network/virtualNetworks/virtualNetworkPeerings@2024-05-01' = {
  parent: hubVirtualNetwork
  name: 'hub-to-spoke'
  properties: {
    allowVirtualNetworkAccess: true
    allowForwardedTraffic: true
    allowGatewayTransit: false
    useRemoteGateways: false
    remoteVirtualNetwork: {
      id: spokeVirtualNetwork.id
    }
  }
}

resource spokeToHubPeering 'Microsoft.Network/virtualNetworks/virtualNetworkPeerings@2024-05-01' = {
  parent: spokeVirtualNetwork
  name: 'spoke-to-hub'
  properties: {
    allowVirtualNetworkAccess: true
    allowForwardedTraffic: true
    allowGatewayTransit: false
    useRemoteGateways: false
    remoteVirtualNetwork: {
      id: hubVirtualNetwork.id
    }
  }
}

// Public IP for NAT Gateway
resource natGatewayPublicIP 'Microsoft.Network/publicIPAddresses@2024-05-01' = {
  name: '${resourcePrefix}-public-ip-nat'
  location: location
  sku: {
    name: 'Standard'
  }
  properties: {
    publicIPAllocationMethod: 'Static'
  }
}

// NAT Gateway
resource natGateway 'Microsoft.Network/natGateways@2024-05-01' = {
  name: '${resourcePrefix}-nat-gateway'
  location: location
  sku: {
    name: 'Standard'
  }
  properties: {
    idleTimeoutInMinutes: 4
    publicIpAddresses: [
      {
        id: natGatewayPublicIP.id
      }
    ]
  }
}

// Public IP for Azure Firewall
resource firewallPublicIP 'Microsoft.Network/publicIPAddresses@2024-05-01' = {
  name: '${resourcePrefix}-public-ip-firewall'
  location: location
  sku: {
    name: 'Standard'
  }
  properties: {
    publicIPAllocationMethod: 'Static'
  }
}

// Firewall Policy
resource firewallPolicy 'Microsoft.Network/firewallPolicies@2024-05-01' = {
  name: '${resourcePrefix}-firewall-policy'
  location: location
  properties: {
    sku: {
      tier: 'Standard'
    }
  }
}

// Firewall Policy Rule Collection Group
resource firewallPolicyRuleCollectionGroup 'Microsoft.Network/firewallPolicies/ruleCollectionGroups@2024-05-01' = {
  parent: firewallPolicy
  name: 'DefaultNetworkRuleCollectionGroup'
  properties: {
    priority: 100
    ruleCollections: [
      {
        ruleCollectionType: 'FirewallPolicyFilterRuleCollection'
        name: 'spoke-to-internet'
        priority: 100
        action: {
          type: 'Allow'
        }
        rules: [
          {
            ruleType: 'NetworkRule'
            name: 'allow-web'
            ipProtocols: [
              'TCP'
            ]
            sourceAddresses: [
              '10.1.0.0/24'
            ]
            destinationAddresses: [
              '*'
            ]
            destinationPorts: [
              '80'
              '443'
            ]
          }
        ]
      }
    ]
  }
}

// Azure Firewall
resource azureFirewall 'Microsoft.Network/azureFirewalls@2024-05-01' = {
  name: '${resourcePrefix}-firewall'
  location: location
  properties: {
    sku: {
      name: 'AZFW_VNet'
      tier: 'Standard'
    }
    ipConfigurations: [
      {
        name: 'IpConfig'
        properties: {
          subnet: {
            id: hubVirtualNetwork.properties.subnets[0].id
          }
          publicIPAddress: {
            id: firewallPublicIP.id
          }
        }
      }
    ]
    firewallPolicy: {
      id: firewallPolicy.id
    }
  }
  dependsOn: [
    firewallPolicyRuleCollectionGroup
  ]
}

// Public IP for Bastion
resource bastionPublicIP 'Microsoft.Network/publicIPAddresses@2024-05-01' = {
  name: '${resourcePrefix}-public-ip-bastion'
  location: location
  sku: {
    name: 'Standard'
  }
  properties: {
    publicIPAllocationMethod: 'Static'
  }
}

// Azure Bastion
resource azureBastion 'Microsoft.Network/bastionHosts@2024-05-01' = {
  name: '${resourcePrefix}-bastion'
  location: location
  sku: {
    name: 'Basic'
  }
  properties: {
    ipConfigurations: [
      {
        name: 'IpConfig'
        properties: {
          subnet: {
            id: hubVirtualNetwork.properties.subnets[1].id
          }
          publicIPAddress: {
            id: bastionPublicIP.id
          }
        }
      }
    ]
  }
}

// Route Table for Spoke
resource spokeRouteTable 'Microsoft.Network/routeTables@2024-05-01' = {
  name: '${resourcePrefix}-route-table-spoke'
  location: location
  properties: {
    disableBgpRoutePropagation: true
    routes: [
      {
        name: 'route-to-hub'
        properties: {
          addressPrefix: '0.0.0.0/0'
          nextHopType: 'VirtualAppliance'
          nextHopIpAddress: azureFirewall.properties.ipConfigurations[0].properties.privateIPAddress
        }
      }
    ]
  }
}

// Network Security Group for Spoke
resource spokeNetworkSecurityGroup 'Microsoft.Network/networkSecurityGroups@2024-05-01' = {
  name: '${resourcePrefix}-nsg-spoke'
  location: location
  properties: {
    securityRules: [
      {
        name: 'DenyDirectInternetOutbound'
        properties: {
          protocol: '*'
          sourcePortRange: '*'
          destinationPortRange: '*'
          sourceAddressPrefix: '*'
          destinationAddressPrefix: 'Internet'
          access: 'Deny'
          priority: 4096
          direction: 'Outbound'
        }
      }
    ]
  }
}

// Network Interface for VM
resource vmNetworkInterface 'Microsoft.Network/networkInterfaces@2024-05-01' = {
  name: '${resourcePrefix}-vm-spoke-nic'
  location: location
  properties: {
    ipConfigurations: [
      {
        name: 'ipconfig1'
        properties: {
          subnet: {
            id: spokeVirtualNetwork.properties.subnets[0].id
          }
          privateIPAllocationMethod: 'Dynamic'
        }
      }
    ]
  }
}

// Test Virtual Machine in Spoke Network
var linuxConfiguration = {
  disablePasswordAuthentication: true
  ssh: {
    publicKeys: [
      {
        path: '/home/${adminUsername}/.ssh/authorized_keys'
        keyData: adminPasswordOrKey
      }
    ]
  }
}

resource testVirtualMachine 'Microsoft.Compute/virtualMachines@2024-07-01' = {
  name: '${resourcePrefix}-vm-spoke'
  location: location
  properties: {
    hardwareProfile: {
      vmSize: 'Standard_B1s'
    }
    osProfile: {
      computerName: take('${resourcePrefix}-vm-spoke', 15)
      adminUsername: adminUsername
      adminPassword: authenticationType == 'password' ? adminPasswordOrKey : null
      linuxConfiguration: authenticationType == 'sshPublicKey' ? linuxConfiguration : null
    }
    storageProfile: {
      imageReference: {
        publisher: 'Canonical'
        offer: '0001-com-ubuntu-server-jammy'
        sku: '22_04-lts-gen2'
        version: 'latest'
      }
      osDisk: {
        createOption: 'FromImage'
        managedDisk: {
          storageAccountType: 'Standard_LRS'
        }
      }
    }
    networkProfile: {
      networkInterfaces: [
        {
          id: vmNetworkInterface.id
        }
      ]
    }
  }
}

// Outputs
output hubVirtualNetworkId string = hubVirtualNetwork.id
output spokeVirtualNetworkId string = spokeVirtualNetwork.id
output natGatewayPublicIP string = natGatewayPublicIP.properties.ipAddress
output firewallPrivateIP string = azureFirewall.properties.ipConfigurations[0].properties.privateIPAddress
output bastionName string = azureBastion.name
output testVMName string = testVirtualMachine.name
output adminUsername string = adminUsername
