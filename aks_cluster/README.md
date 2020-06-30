# AKS Cluster

This module provisions an AKS cluster within Azure. The module can be configured to enable AAD RBAC integration. Review the table below for full configuration details. Check out the example directory for different ways to use the module.

## Requirements

- Terraform v0.12.13+
- Azure account and credentials
- Logged into the Azure cli
- Azure resource group
- Azure virtual network and subnet

## Kube Configuration

Once the cluster has been provisioned, it can be accessed with either the `admin` credentials or `AAD` user group credentials.

### admin credentials

If needed, use the admin credentials directly.
```bash
$ az aks get-credentials --resource-group myakscluster --name myakscluster --admin
```

### AAD User

If `enable_aad_auth` is set to true, you can authenticate against the cluster using your az account. Add the user to the `clusteradmin` group in AAD created by Terraform. Then use the az cli to get the credentials.

```bash
$ az aks get-credentials --resource-group kubernates --name myakscluster
Merged "myakscluster" as current context in /home/$user/.kube/config
$ kubectl get nodes
To sign in, use a web browser to open the page https://microsoft.com/devicelogin and enter the code FLBV5XKT7 to authenticate.
NAME                                STATUS   ROLES   AGE   VERSION
aks-default-14693408-vmss000000     Ready    agent   34m   v1.15.9
```

### Egress IP Configuration

This module supports static ip addresses for egress. Addresses can be created ahead of time, or provisioned during cluster creation. This is configured via `managed_outbound_ip_count`, `outbound_ip_address_ids`, `outbound_ip_prefix_ids`. See the `variables` section for details. **Do not mix and match these variables.**


## Configuration

The following table lists the configurable parameters that this module accepts.

| Parameter                               | Description                                                          | Default    |
|-----------------------------------------|----------------------------------------------------------------------|------------|
| `admin_username`                        | The username set in linux_profile                                    | `"admin"`  |
| `cluster_name`                          | Name of the AKS cluster                                              | `None`     |
| `docker_bridge_cidr`                    | The docker daemon host cidr                                          | `null`     |
| `kubernetes_version`                    | The Kubernetes AKS version                                           | `null`     |
| `load_balancer_sku`                     | The load balancer type. Supported values: basic, standard            | `standard` |
| `load_balancer_idle_timeout_in_minutes` | Desired outbound flow idle timeout in minutes for the load balancer  | `30`       |
| `managed_outbound_ip_count`             | The number of egress ips provisioned during cluster creation         | `null`     |
| `outbound_ip_address_ids`               | List of `azurerm_public_ip` ids                                      | `null`     |
| `outbound_ip_prefix_ids`                | IDs of the outbound Public IP Address Prefixes                       | `null`     |
| `outbound_ports_allocation`             | Number of desired SNAT port for each VM in the load balancer         | `0`        |
| `network_plugin`                        | The CNI network plugin to use (only azure, or kubenet)               | `kubenet`  |
| `node_subnet_id`                        | The subnet ID for the default node pool                              | `None`     |
| `network_policy`                        | The network policy for the CNI, dependent on plugin type             | `null`     |
| `pod_cidr`                              | Network CIDR range for the pod network                               | `null`     |
| `public_ssh_key_path`                   | The SSH public key attached the linux_profile                        | `None`     |
| `region`                                | The Azure region                                                     | `None`     |
| `resource_group_name`                   | The resource group to place the AKS cluster in                       | `None`     |
| `service_cidr`                          | The CIDR range for Kubernetes services                               | `null`     |
| `aks_sp_secret`                         | Optional service principal password for the AKS cluster              | `null`     |
| `auth_client_sp_secret`                 | Secret password attached to the AAD Server service principal         | `null`     |
| `auth_server_sp_secret`                 | Secret password attached to the AAD Client service principal         | `null`     |
| `additional_tags`                       | A map of tags to be auto-attached to resources                       | `{}`       |
| `enable_aad_auth`                       | Enable AAD authentication for Kubernetes API                         | `false`    |
| `enable_rbac`                           | Enable RBAC for the Kubernetes API                                   | `true`     |
| `enable_http_application_routing`       | Turns on azure http application routing                              | `false`    |
| `enable_kube_dashboard`                 | Enables the kubernetes web dashboard                                 | `false`    |
| `enable_aci_connector_linux`            | Enables the aci connector                                            | `false`    |
| `enable_azure_policy`                   | Enables the azure policy                                             | `false`    |
| `log_analytics_workspace_id`            | If set, enables the OMS agent cluster addon                          | `null`     |

### default_node_pool configuration

| Parameter                 | Description                                                  | Default            |
|---------------------------|--------------------------------------------------------------|--------------------|
| `node_availability_zones` | Azure availability zones to use                              | `[1, 2, 3]`        |
| `enable_auto_scaling`     | Boolean to enable/disable autoscaling                        | `true`             |
| `enable_node_public_ip`   | Boolean to enable allocation of public ips to nodes          | `false`            |
| `node_max_count`          | Max amount of nodes to autoscale                             | `20`               |
| `node_max_pods`           | Max amount of pods per node (subject to CNI)                 | `200`              |
| `node_min_count`          | Min amount of nodes for autoscaling (must be greater than 0) | `1`                |
| `node_count`              | The initial node count. This value is ignored after cluster creation due to autoscaler conflicts. | `1`                |
| `node_taints`             | Taints to apply to nodes                                     | `null`             |
| `os_disk_size_gb`         | The root disk size for VMs                                   | `35`               |
| `node_type`               | The Azure VM instance type                                   | `"Standard_D2_v2"` |

## Outputs

| Ouput               |           Description |
|---------------------|-----------------------|
| `id`                | The AKS cluster ID    |
| `kube_admin_config` | The admin kube config |
