## yaml_data_in_modules : a data in modules backend for Hiera

### Requirement

puppet >= 3.2.3
hiera >= 1.2.1

### Description

This backend will check for yaml files in a directory called "data" of the current puppet module.

### How to install it

Add this module to your Puppetfile to install "data in modules" as a new backend

    mod 'yaml_data_in_modules',
        :git => "git@github.com:mythsunwind/yaml_data_in_modules.git"

### How to use it with hiera

Add the backend to your hiera.yaml

    :backends:
      - yaml_data_in_modules
      - yaml
    :hierarchy:
      - %{context}-%{datacenter}-%{platform}-%{cluster}-%{hostname}
      - %{context}-%{datacenter}-%{platform}-%{cluster}
      - %{context}-%{datacenter}-%{platform}
      - %{context}-%{datacenter}
      - %{context}
      - common

The above configuration will check hierachically in the data directory for yaml files with the specified names. If it didn't found any files with the given names (concatinated with facts and common.yaml), the above configuration will then switch to the normal yaml backend and check at the central location.

### How to add data to your module

In your module path create a directory called *data* and add yaml files into it.

    modules/example_module/
                          + files
                          + manifests
                          + templates
                          + data
                            + dev-eu--vm116.yaml
                            + qa-na.yaml
                            + common.yaml

Add a variable to your yaml files

    version : "1.23.4-567"
    
Use the following syntax to use this variable in your module

    class my_module {
      $version = hiera("version")
    }
