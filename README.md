# livipod_app

A new Flutter project.

## Things to know
To build models execute the following from the command line:
dart run build_runner build --delete-conflicting-outputs



## Getting Started

1- You have to create a `key.properties` file in android folder and add the following content

``` 
storePassword=qwopzx1@qwopzx1@
keyPassword=qwopzx1@qwopzx1@
keyAlias=LiviPod
storeFile=../../indygo.jks
```

2- You also have to add `indygo.jks` to the root folder of your project.

3- It's recommended to add the symbols folder to the root directory of the project. This will be helpful if you need to de-obfuscate the code in the future.