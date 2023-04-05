# Execute the Main method of the MyClass class in MyLibrary.dll with the arguments "arg1" and "arg2"
#execute_main_method "/path/to/MyLibrary.dll" "MyNamespace.MyClass" "arg1" "arg2"
#dotnet /path/to/MyLibrary.dll MyNamespace.MyClass::Main arg1 arg2


#ChatGPT: Please write a bash function to execute a main method given the arguments of a .dll file path, the qualified class name, and the remaining arguments will be the arguments to the main method.

# Parse the arguments
  local dll_path="$1"
  local class_name="$2"
  shift 2
  local args="$@"

  # Build the command to execute
  local command="dotnet $dll_path"

  # Append the class name and the main method signature
  command="$command $class_name::Main"

  # Append the remaining arguments
  command="$command $args"

  # Execute the command
  eval "$command"
