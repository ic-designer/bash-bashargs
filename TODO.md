# TODO

1. Agree on the standard make targets and list them all at the topof the file. Maybe use the following pattern:
    ```make
        <name>: private_<name>
    ```

2. Figure out a standard way of pulling dependecies like `waxwing`. It would be cool if you there was a shared recipe that provided a way to dynamically create a makefile that cloned the repo, built the executables, created standardized variables to access that executable from other recipes.

3. Create standard that describes the following:
    - How to structure bash scripts
    - How scripts are combined to create libraries and executables.
