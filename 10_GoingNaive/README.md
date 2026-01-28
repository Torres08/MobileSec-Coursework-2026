# goingnative

example looking java classes and c/c++ .so
___


```java
if (!flag.startsWith("FLAG{") || !flag.endsWith("}")) {
            return "Invalid flag";
        }
        String flag2 = flag.replace("FLAG{", "").replace("}", "");
        if (flag2.length() == 15 && checkFlag(flag2) != -1) {
            return "Correct flag!";
        }
```
The java code suggests that the flag should be in the format FLAG{*} and with an internal length of 15 charact



```java
public native int checkFlag(String str);
static {
System.loadLibrary("goingnative");
}
```

System.loadLibrary("goingnative"); -> this means that uses .so that we need to look -> GHIDRA tool -> check assembly 


decompile the apk like a zip and look for libgoingnative.so going native -> lib -> x86_64

drag + drop the .so into the ghidra -> left panel -> functions look for 

```c++
undefined4 validate_input(char *param_1)

{
  int iVar1;
  long in_FS_OFFSET;
  int local_30;
  char *local_28;
  undefined4 local_18;
  char local_12 [2];
  long local_10;
  
  local_10 = *(long *)(in_FS_OFFSET + 0x28);
  local_12[0] = '_';
  local_12[1] = '\0';
  local_28 = strtok(param_1,local_12);
  local_30 = 0;
  do {
    if (local_28 == (char *)0x0) {
      if (local_30 == 0) {
        local_18 = 0xffffffff;
      }
      else {
        local_18 = 0;
      }
LAB_0010083a:
      if (*(long *)(in_FS_OFFSET + 0x28) == local_10) {
        return local_18;
      }
                    /* WARNING: Subroutine does not return */
      __stack_chk_fail();
    }
    if (local_30 == 0) {
      iVar1 = strcmp(local_28,"status");
      if (iVar1 != 0) {
        local_18 = 0xffffffff;
        goto LAB_0010083a;
      }
    }
    if (local_30 == 1) {
      iVar1 = strcmp(local_28,"1234");
      if (iVar1 != 0) {
        local_18 = 0xffffffff;
        goto LAB_0010083a;
      }
    }
    if (local_30 == 2) {
      iVar1 = strcmp(local_28,"quo");
      if (iVar1 != 0) {
        local_18 = 0xffffffff;
        goto LAB_0010083a;
      }
    }
    local_28 = strtok((char *)0x0,local_12);
    local_30 = local_30 + 1;
  } while( true );
}
```

see that flag divide into status 123 quo with separator   local_12[0] = '_';

FLAG{status_1234_quo}
