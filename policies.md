<p align="center">
  <img src="./images/logo-classicblue-800px.png" alt="Intel Logo" width="250"/>
</p>

# Intel® Cloud Optimization Modules for Terraform  

© Copyright 2022, Intel Corporation

## HashiCorp Sentinel Policies

This file documents the HashiCorp Sentinel policies that apply to this module

## Policy 1

Description: Azure Managed Instance Apache Cassandra Intel Recommended SKU: E-v5, and Lsv3-series run on the 3rd Generation Intel® Xeon® Platinum 8370C (Ice Lake), the Intel® Xeon® Platinum 8272CL (Cascade Lake) processors, or the Intel® Xeon® Platinum 8168 (Skylake) processors.

The Ev5 series virtual machines are based on the 3rd Generation Intel® Xeon® Platinum 8370C (Ice Lake) processor in a hyper-threaded configuration. This custom processor can reach an all-core Turbo clock speed of up to 3.5GHz and features Intel® Turbo Boost Technology 2.0, Intel® Advanced Vector Extensions 512 (Intel® AVX-512) and Intel® Deep Learning Boost.

The Lsv3 VM series features high throughput, low latency, directly mapped local NVMe storage and are based on the 3rd Generation Intel® Xeon® Platinum 8370C (Ice Lake) processor in a hyper-threaded configuration. 

The Dsv5 series virtual machines are based on the 3rd Generation Intel® Xeon® Platinum 8370C (Ice Lake) processor in a hyper-threaded configuration. This custom processor can reach an all-core Turbo clock speed of up to 3.5GHz and features Intel® Turbo Boost Technology 2.0, Intel® Advanced Vector Extensions 512 (Intel® AVX-512) and Intel® Deep Learning Boost.

The Dsv4 series virtual machines feature the Intel® Xeon® Platinum 8272CL (second generation Intel® Xeon® Scalable processor.) 

D11-15S v2 virtual machines are based on the Intel® Xeon® Platinum 8272CL (second generation Intel® Xeon® Scalable processors), the Intel® Xeon® 8171M 2.1 GHz (Skylake), the 2.3 GHz Intel Xeon® E5-2673 v4 (Broadwell) or the 2.4 GHz Intel Xeon® E5-2673 v3 (Haswell) processors. T

The Ev4 series virtual machines are based on the Intel® Xeon® Platinum 8272CL (second generation Intel® Xeon® Scalable processor.) This custom processor runs at a base speed of 2.5Ghz and can achieve up to 3.4Ghz all core turbo frequency.


Resource type:  resource "azurerm_cosmosdb_cassandra_datacenter


Parameter:  sku_name

Allowed Types :  **Add allowed resource types of the policy. This will be removed !**

Standard_D2s_v5, Standard_D4s_v5, Standard_D8s_v5, Standard_D16_v5, Standard_D22s_v5
Standard_E2s_v5, Standard_E4s_v5, Standard_E8s_v5, Standard_E16s_v5, Standard_E20s_v5, Standard_E32s_v5
Standard_L8s_v3, Standard_L8s_v3, Standard_L32s_v3

#Standard_D8s_v4, Standard_D16s_v4, Standard_D32s_v4 
#Standard_DS13_v2, Standard_DS14_v2 
#Standard_E8_v4, Standard_E16_v4, Standard_E20_v4, Standard_E32_v4
