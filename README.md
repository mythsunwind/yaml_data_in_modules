## yaml_data_in_modules : a data in modules backend for Hiera

### Description

This backend will check for yaml files in a directory called "data" of the current puppet module.

### How to install it

Add this module to your Puppetfile to install "data in modules" as a new backend

    mod 'yaml_data_in_modules',
        :git => "git@git.spreadomat.net:svj/data_in_modules.git"

### How to use it with hiera

Add the backend to your hiera.yaml

    :backends:
      - yaml_data_in_modules
      - yaml
    :hierarchy:
      - %{environment}-%{platform}-%{cluster}-%{hostname}
      - %{environment}-%{platform}-%{cluster}
      - %{environment}-%{platform}
      - %{environment}
      - common

The above configuration will check hierachically in the data directory for yaml files with the specified names. If it didn't found any files with the given names (concatinated with facts and common.yaml), the above configuration will then switch to the normal yaml backend and check at the central location.

