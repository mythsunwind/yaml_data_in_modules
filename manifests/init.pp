class hiera_data_in_modules {

     $variable2 = hiera('variable2')

     notify { "$variable2": }

}
