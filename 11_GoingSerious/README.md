# GoingSerious 



Decompile the apk with jadx.

Open the MainActivity.java file and look at the code. The flag is checked in the checkFlag function. This is a native function, so we need to look at the native c++ code.

In the /lib/x86_64/ folder we can find the libgoingseriousnative.so file. Open it with a program like IDA to check the disassembled content.

The entry point of the program is the Main Activity function. In particular the preprocessing function is called here. We are going to analize this function.

```c++

undefined4 preprocessing(char *param_1)

{
  long in_FS_OFFSET;
  int local_4c;
  char *local_48;
  undefined4 local_34;
  undefined4 local_30;
  char local_2a [2];
  undefined4 local_28 [6];
  long local_10;
  
  local_10 = *(long *)(in_FS_OFFSET + 0x28);
  local_2a[0] = ' ';
  local_2a[1] = '\0';
  local_48 = strtok(param_1,local_2a);
  local_4c = 0;
  while (local_48 != (char *)0x0) {
    sscanf(local_48,"%d",&local_30);
    local_28[local_4c] = local_30;
    local_48 = strtok((char *)0x0,local_2a);
    local_4c = local_4c + 1;
  }
  if (local_4c == 5) {
    local_34 = validate(local_28);
  }
  else {
    local_34 = 0xffffffff;
  }
  if (*(long *)(in_FS_OFFSET + 0x28) == local_10) {
    return local_34;
  }
```

A string is tokenized with strtok function and the space character as delimiter. From the tokens are extracted integers values and, if these values are five in total, a validate function is now called.

The validate cicles through the 5 elements of the array created in the previous function and adds them to a variable. If the sum of the elements is equal to 100 the program returns 0, which is what the java code is expecting. There are multiple pins that we can use to get the correct sum. For instance, 100 0 0 0 0 or 20 20 20 20 20.

The flag is printed: FLAG{omnia_prius_experiri_quam_armis_sapientem_decet}.

To summarize, the PIN expected by the app should contain 5 digits, which sum should be greater than 100.