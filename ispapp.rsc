:global topUrl "https://#####DOMAIN#####:8550/";
:global topClientInfo "RouterOS-v1.54";
:global topKey "#####HOST_KEY#####";
:if ([:len [/system scheduler find name=cmdGetDataFromApi]] > 0) do={
    /system scheduler remove [find name="cmdGetDataFromApi"]
}
:if ([:len [/system scheduler find name=collectors]] > 0) do={
    /system scheduler remove [find name="collectors"]
}
:if ([:len [/system scheduler find name=initMultipleScript]] > 0) do={
    /system scheduler remove [find name="initMultipleScript"]
}
:if ([:len [/system scheduler find name=update-schedule]] > 0) do={
    /system scheduler remove [find name="update-schedule"]
}
:if ([:len [/system scheduler find name=update-script]] > 0) do={
    /system scheduler remove [find name="update-script"]
}
:if ([:len [/system scheduler find name=boot]] > 0) do={
    /system scheduler remove [find name="boot"]
}
:if ([:len [/system scheduler find name=config]] > 0) do={
    /system scheduler remove [find name="config"]
}
:if ([:len [/system scheduler find name=pingCollector]] > 0) do={
    /system scheduler remove [find name="pingCollector"]
}
:delay 1;
:if ([:len [/system script find name=JParseFunctions]] > 0) do={
    /system script remove [find name="JParseFunctions"]
}
:if ([:len [/system script find name=base64EncodeFunctions]] > 0) do={
    /system script remove [find name="base64EncodeFunctions"]
}
:if ([:len [/system script find name=cmdGetDataFromApi]] > 0) do={
    /system script remove [find name="cmdGetDataFromApi"]
}
:if ([:len [/system script find name=cmdGetDataFromApi.rsc]] > 0) do={
    /system script remove [find name="cmdGetDataFromApi.rsc"]
}
:if ([:len [/system script find name=cmdScript]] > 0) do={
    /system script remove [find name="cmdScript"]
}
:if ([:len [/system script find name=cmdScript.rsc]] > 0) do={
    /system script remove [find name="cmdScript.rsc"]
}
:if ([:len [/system script find name=collectors]] > 0) do={
    /system script remove [find name="collectors"]
}
:if ([:len [/system script find name=collectors.rsc]] > 0) do={
    /system script remove [find name="collectors.rsc"]
}
:if ([:len [/system script find name=config]] > 0) do={
    /system script remove [find name="config"]
}
:if ([:len [/system script find name=globalScript]] > 0) do={
    /system script remove [find name="globalScript"]
}
:if ([:len [/system script find name=initMultipleScript]] > 0) do={
    /system script remove [find name="initMultipleScript"]
}
:if ([:len [/system script find name=update]] > 0) do={
    /system script remove [find name="update"]
}
:if ([:len [/system script find name=update.rsc]] > 0) do={
    /system script remove [find name="update.rsc"]
}
:if ([:len [/system script find name=boot]] > 0) do={
    /system script remove [find name="boot"]
}
:if ([:len [/system script find name=lteCollector]] > 0) do={
    /system script remove [find name="lteCollector"]
}
:if ([:len [/system script find name=avgCpuCollector]] > 0) do={
    /system script remove [find name="avgCpuCollector"]
}
:if ([:len [/system script find name=pingCollector]] > 0) do={
    /system script remove [find name="pingCollector"]
}
:delay 1;
/system script
add dont-require-permissions=no name=globalScript owner=admin policy=ftp,reboot,read,write,policy,test,password,sniff,sensitive,romon source=":global startEncode 1;\r\
    \n:global isSend 1;\r\
    \n\r\
    \n:global topUrl;\r\
    \n:global topClientInfo;\r\
    \n:global topKey;\r\
    \n\r\
    \n:set topKey (\"$topKey\");\r\
    \n:set topUrl (\"$topUrl\");\r\
    \n:set topClientInfo (\"$topClientInfo\");\r\
    \n\r\
    \n:global currentUrlVal;\r\
    \n\r\
    \n# Get MAC address from wlan1\r\
    \n:global login;\r\
    \n\r\
    \n:do {\r\
    \n  :set login ([/interface get [find default-name=wlan1] mac-address]);\r\
    \n  :put \$login;\r\
    \n} on-error={\r\
    \n  :put \"using ether1 mac address\";\r\
    \n  :set login ([/interface ethernet get [find default-name=ether1] mac-address]);\r\
    \n}\r\
    \n\r\
    \n# Convert to lowercase\r\
    \n:local low (\"a\",\"b\",\"c\",\"d\",\"e\",\"f\",\"g\",\"h\",\"i\",\"j\",\"k\",\"l\",\"m\",\"n\",\"o\",\"p\",\"q\",\"r\",\"s\",\"t\",\"u\",\"v\",\"w\",\"x\",\"y\",\"z\");\r\
    \n:local upp (\"A\",\"B\",\"C\",\"D\",\"E\",\"F\",\"G\",\"H\",\"I\",\"J\",\"K\",\"L\",\"M\",\"N\",\"O\",\"P\",\"Q\",\"R\",\"S\",\"T\",\"U\",\"V\",\"W\",\"X\",\"Y\",\"Z\");\r\
    \n:local new \"\";\r\
    \n\r\
    \n:for i from=0 to=([:len \$login] - 1) do={\r\
    \n  :local char [:pick \$login \$i];\r\
    \n  :local f [:find \"\$upp\" \"\$char\"];\r\
    \n  :if ( \$f < 0 ) do={\r\
    \n  :set new (\$new . \$char);\r\
    \n  }\r\
    \n  :for a from=0 to=([:len \$upp] - 1) do={\r\
    \n  :local l [:pick \$upp \$a];\r\
    \n  :if ( \$char = \$l) do={\r\
    \n    :local u [:pick \$low \$a];\r\
    \n    :set new (\$new . \$u);\r\
    \n    }\r\
    \n  }\r\
    \n}\r\
    \n\r\
    \n:set login \$new;\r\
    \n\r\
    \n:global urlEncodeFunct do={\r\
    \n  :put \"\$currentUrlVal\"; \r\
    \n  :put \"\$urlVal\"\r\
    \n\r\
    \n  :local urlEncoded;\r\
    \n  :for i from=0 to=([:len \$urlVal] - 1) do={\r\
    \n    :local char [:pick \$urlVal \$i]\r\
    \n    :if (\$char = \" \") do={\r\
    \n      :set char \"%20\"\r\
    \n    }\r\
    \n    :if (\$char = \"/\") do={\r\
    \n      :set char \"%2F\"\r\
    \n    }\r\
    \n    :if (\$char = \"-\") do={\r\
    \n      :set char \"%2D\"\r\
    \n    }\r\
    \n    :set urlEncoded (\$urlEncoded . \$char)\r\
    \n  }\r\
    \n  :local mergeUrl;\r\
    \n  :set mergeUrl (\$currentUrlVal . \$urlEncoded);\r\
    \n  :return (\$mergeUrl);\r\
    \n\r\
    \n}\r\
    \n\r\
    \n:put (\"globalScript executed, login: \$login\");"
add dont-require-permissions=no name=JParseFunctions owner=admin policy=ftp,reboot,read,write,policy,test,password,sniff,sensitive,romon source="# --------------------------------\
    \_JParseFunctions -------------------\r\
    \n:global fJParsePrint;\r\
    \n:if (!any \$fJParsePrint) do={ :global fJParsePrint do={\r\
    \n  :global JParseOut;\r\
    \n  :local TempPath;\r\
    \n  :global fJParsePrint;\r\
    \n\r\
    \n  :if ([:len \$1] = 0) do={\r\
    \n    :set \$1 \$JParseOut;\r\
    \n    :set \$2 \$JParseOut;\r\
    \n   }\r\
    \n  \r\
    \n  :foreach k,v in=\$2 do={\r\
    \n    :if ([:typeof \$k] = \"str\") do={\r\
    \n      :set k \"\\\"\$k\\\"\";\r\
    \n    }\r\
    \n    :set TempPath (\$1. \"->\" . \$k);\r\
    \n    :if ([:typeof \$v] = \"array\") do={\r\
    \n      :if ([:len \$v] > 0) do={\r\
    \n        \$fJParsePrint \$TempPath \$v;\r\
    \n      } else={\r\
    \n        :put \"\$TempPath = [] (\$[:typeof \$v])\";\r\
    \n      }\r\
    \n    } else={\r\
    \n        :put \"\$TempPath = \$v (\$[:typeof \$v])\";\r\
    \n    }\r\
    \n  }\r\
    \n}}\r\
    \n# ------------------------------- fJParsePrintVar ----------------------------------------------------------------\r\
    \n:global fJParsePrintVar;\r\
    \n:if (!any \$fJParsePrintVar) do={ :global fJParsePrintVar do={\r\
    \n  :global JParseOut;\r\
    \n  :local TempPath;\r\
    \n  :global fJParsePrintVar;\r\
    \n  :local fJParsePrintRet \"\";\r\
    \n\r\
    \n  :if ([:len \$1] = 0) do={\r\
    \n    :set \$1 \$JParseOut;\r\
    \n    :set \$2 \$JParseOut;\r\
    \n   }\r\
    \n  \r\
    \n  :foreach k,v in=\$2 do={\r\
    \n    :if ([:typeof \$k] = \"str\") do={\r\
    \n      :set k \"\\\"\$k\\\"\";\r\
    \n    }\r\
    \n    :set TempPath (\$1. \"->\" . \$k);\r\
    \n    :if (\$fJParsePrintRet != \"\") do={\r\
    \n      :set fJParsePrintRet (\$fJParsePrintRet . \"\\r\\n\");\r\
    \n    }   \r\
    \n    :if ([:typeof \$v] = \"array\") do={\r\
    \n      :if ([:len \$v] > 0) do={\r\
    \n        :set fJParsePrintRet (\$fJParsePrintRet . [\$fJParsePrintVar \$TempPath \$v]);\r\
    \n      } else={\r\
    \n        :set fJParsePrintRet (\$fJParsePrintRet . \"\$TempPath = [] (\$[:typeof \$v])\");\r\
    \n      }\r\
    \n    } else={\r\
    \n        :set fJParsePrintRet (\$fJParsePrintRet . \"\$TempPath = \$v (\$[:typeof \$v])\");\r\
    \n    }\r\
    \n  }\r\
    \n  :return \$fJParsePrintRet;\r\
    \n}}\r\
    \n# ------------------------------- fJSkipWhitespace ----------------------------------------------------------------\r\
    \n:global fJSkipWhitespace;\r\
    \n:if (!any \$fJSkipWhitespace) do={ :global fJSkipWhitespace do={\r\
    \n  :global Jpos;\r\
    \n  :global JSONIn;\r\
    \n  :global Jdebug;\r\
    \n  :while (\$Jpos < [:len \$JSONIn] and ([:pick \$JSONIn \$Jpos] ~ \"[ \\r\\n\\t]\")) do={\r\
    \n    :set Jpos (\$Jpos + 1);\r\
    \n  }\r\
    \n  :if (\$Jdebug) do={:put \"fJSkipWhitespace: Jpos=\$Jpos Char=\$[:pick \$JSONIn \$Jpos]\";}\r\
    \n}}\r\
    \n# -------------------------------- fJParse ---------------------------------------------------------------\r\
    \n:global fJParse;\r\
    \n:if (!any \$fJParse) do={ :global fJParse do={\r\
    \n  :global Jpos;\r\
    \n  :global JSONIn;\r\
    \n  :global Jdebug;\r\
    \n  :global fJSkipWhitespace;\r\
    \n  :local Char;\r\
    \n\r\
    \n  :if (!\$1) do={\r\
    \n    :set Jpos 0;\r\
    \n   }\r\
    \n \r\
    \n  \$fJSkipWhitespace;\r\
    \n  :set Char [:pick \$JSONIn \$Jpos];\r\
    \n  :if (\$Jdebug) do={:put \"fJParse: Jpos=\$Jpos Char=\$Char\"};\r\
    \n  :if (\$Char=\"{\") do={\r\
    \n    :set Jpos (\$Jpos + 1);\r\
    \n    :global fJParseObject;\r\
    \n    :return [\$fJParseObject];\r\
    \n  } else={\r\
    \n    :if (\$Char=\"[\") do={\r\
    \n      :set Jpos (\$Jpos + 1);\r\
    \n      :global fJParseArray;\r\
    \n      :return [\$fJParseArray];\r\
    \n    } else={\r\
    \n      :if (\$Char=\"\\\"\") do={\r\
    \n        :set Jpos (\$Jpos + 1);\r\
    \n        :global fJParseString;\r\
    \n        :return [\$fJParseString];\r\
    \n      } else={\r\
    \n#        :if ([:pick \$JSONIn \$Jpos (\$Jpos+2)]~\"^-\\\?[0-9]\") do={\r\
    \n        :if (\$Char~\"[eE0-9.+-]\") do={\r\
    \n          :global fJParseNumber;\r\
    \n          :return [\$fJParseNumber];\r\
    \n        } else={\r\
    \n\r\
    \n          :if (\$Char=\"n\" and [:pick \$JSONIn \$Jpos (\$Jpos+4)]=\"null\") do={\r\
    \n            :set Jpos (\$Jpos + 4);\r\
    \n            :return [];\r\
    \n          } else={\r\
    \n            :if (\$Char=\"t\" and [:pick \$JSONIn \$Jpos (\$Jpos+4)]=\"true\") do={\r\
    \n              :set Jpos (\$Jpos + 4);\r\
    \n              :return true;\r\
    \n            } else={\r\
    \n              :if (\$Char=\"f\" and [:pick \$JSONIn \$Jpos (\$Jpos+5)]=\"false\") do={\r\
    \n                :set Jpos (\$Jpos + 5);\r\
    \n                :return false;\r\
    \n              } else={\r\
    \n                :put \"JParseFunctions.fJParse script: Err.Raise 8732. No JSON object could be fJParsed\";\r\
    \n                :set Jpos (\$Jpos + 1);\r\
    \n                :return \"Err.Raise 8732. No JSON object could be fJParsed\";\r\
    \n              }\r\
    \n            }\r\
    \n          }\r\
    \n        }\r\
    \n      }\r\
    \n    }\r\
    \n  }\r\
    \n}}\r\
    \n\r\
    \n#-------------------------------- fJParseString ---------------------------------------------------------------\r\
    \n:global fJParseString;\r\
    \n:if (!any \$fJParseString) do={ :global fJParseString do={\r\
    \n  :global Jpos;\r\
    \n  :global JSONIn;\r\
    \n  :global Jdebug;\r\
    \n  :global fUnicodeToUTF8;\r\
    \n  :local Char;\r\
    \n  :local StartIdx;\r\
    \n  :local Char2;\r\
    \n  :local TempString \"\";\r\
    \n  :local UTFCode;\r\
    \n  :local Unicode;\r\
    \n\r\
    \n  :set StartIdx \$Jpos;\r\
    \n  :set Char [:pick \$JSONIn \$Jpos];\r\
    \n  :if (\$Jdebug) do={:put \"fJParseString: Jpos=\$Jpos Char=\$Char\";}\r\
    \n  :while (\$Jpos < [:len \$JSONIn] and \$Char != \"\\\"\") do={\r\
    \n    :if (\$Char=\"\\\\\") do={\r\
    \n      :set Char2 [:pick \$JSONIn (\$Jpos + 1)];\r\
    \n      :if (\$Char2 = \"u\") do={\r\
    \n        :set UTFCode [:tonum \"0x\$[:pick \$JSONIn (\$Jpos+2) (\$Jpos+6)]\"];\r\
    \n        :if (\$UTFCode>=0xD800 and \$UTFCode<=0xDFFF) do={\r\
    \n# Surrogate pair\r\
    \n          :set Unicode  ((\$UTFCode & 0x3FF) << 10);\r\
    \n          :set UTFCode [:tonum \"0x\$[:pick \$JSONIn (\$Jpos+8) (\$Jpos+12)]\"];\r\
    \n          :set Unicode (\$Unicode | (\$UTFCode & 0x3FF) | 0x10000);\r\
    \n          :set TempString (\$TempString . [:pick \$JSONIn \$StartIdx \$Jpos] . [\$fUnicodeToUTF8 \$Unicode]);\r\
    \n          :set Jpos (\$Jpos + 12);\r\
    \n        } else= {\r\
    \n# Basic Multilingual Plane (BMP)\r\
    \n          :set Unicode \$UTFCode;\r\
    \n          :set TempString (\$TempString . [:pick \$JSONIn \$StartIdx \$Jpos] . [\$fUnicodeToUTF8 \$Unicode]);\r\
    \n          :set Jpos (\$Jpos + 6);\r\
    \n        }\r\
    \n        :set StartIdx \$Jpos;\r\
    \n        :if (\$Jdebug) do={:put \"fJParseString Unicode: \$Unicode\";}\r\
    \n      } else={\r\
    \n        :if (\$Char2 ~ \"[\\\\bfnrt\\\"]\") do={\r\
    \n          :if (\$Jdebug) do={:put \"fJParseString escape: Char+Char2 \$Char\$Char2\";}\r\
    \n          :set TempString (\$TempString . [:pick \$JSONIn \$StartIdx \$Jpos] . [[:parse \"(\\\"\\\\\$Char2\\\")\"]]);\r\
    \n          :set Jpos (\$Jpos + 2);\r\
    \n          :set StartIdx \$Jpos;\r\
    \n        } else={\r\
    \n          :if (\$Char2 = \"/\") do={\r\
    \n            :if (\$Jdebug) do={:put \"fJParseString /: Char+Char2 \$Char\$Char2\";}\r\
    \n            :set TempString (\$TempString . [:pick \$JSONIn \$StartIdx \$Jpos] . \"/\");\r\
    \n            :set Jpos (\$Jpos + 2);\r\
    \n            :set StartIdx \$Jpos;\r\
    \n          } else={\r\
    \n            :put \"JParseFunctions.fJParseString script: Err.Raise 8732. Invalid escape\";\r\
    \n            :set Jpos (\$Jpos + 2);\r\
    \n          }\r\
    \n        }\r\
    \n      }\r\
    \n    } else={\r\
    \n      :set Jpos (\$Jpos + 1);\r\
    \n    }\r\
    \n    :set Char [:pick \$JSONIn \$Jpos];\r\
    \n  }\r\
    \n  :set TempString (\$TempString . [:pick \$JSONIn \$StartIdx \$Jpos]);\r\
    \n  :set Jpos (\$Jpos + 1);\r\
    \n  :if (\$Jdebug) do={:put \"fJParseString: \$TempString\";}\r\
    \n  :return \$TempString;\r\
    \n}}\r\
    \n\r\
    \n#-------------------------------- fJParseNumber ---------------------------------------------------------------\r\
    \n:global fJParseNumber;\r\
    \n:if (!any \$fJParseNumber) do={ :global fJParseNumber do={\r\
    \n  :global Jpos;\r\
    \n  :local StartIdx;\r\
    \n  :global JSONIn;\r\
    \n  :global Jdebug;\r\
    \n  :local NumberString;\r\
    \n  :local Number;\r\
    \n\r\
    \n  :set StartIdx \$Jpos;\r\
    \n  :set Jpos (\$Jpos + 1);\r\
    \n  :while (\$Jpos < [:len \$JSONIn] and [:pick \$JSONIn \$Jpos]~\"[eE0-9.+-]\") do={\r\
    \n    :set Jpos (\$Jpos + 1);\r\
    \n  }\r\
    \n  :set NumberString [:pick \$JSONIn \$StartIdx \$Jpos];\r\
    \n  :set Number [:tonum \$NumberString];\r\
    \n  :if ([:typeof \$Number] = \"num\") do={\r\
    \n    :if (\$Jdebug) do={:put \"fJParseNumber: StartIdx=\$StartIdx Jpos=\$Jpos \$Number (\$[:typeof \$Number])\"}\r\
    \n    :return \$Number;\r\
    \n  } else={\r\
    \n    :if (\$Jdebug) do={:put \"fJParseNumber: StartIdx=\$StartIdx Jpos=\$Jpos \$NumberString (\$[:typeof \$NumberString])\"}\r\
    \n    :return \$NumberString;\r\
    \n  }\r\
    \n}}\r\
    \n\r\
    \n#-------------------------------- fJParseArray ---------------------------------------------------------------\r\
    \n:global fJParseArray;\r\
    \n:if (!any \$fJParseArray) do={ :global fJParseArray do={\r\
    \n  :global Jpos;\r\
    \n  :global JSONIn;\r\
    \n  :global Jdebug;\r\
    \n  :global fJParse;\r\
    \n  :global fJSkipWhitespace;\r\
    \n  :local Value;\r\
    \n  :local ParseArrayRet [:toarray \"\"];\r\
    \n\r\
    \n  \$fJSkipWhitespace;\r\
    \n  :while (\$Jpos < [:len \$JSONIn] and [:pick \$JSONIn \$Jpos]!= \"]\") do={\r\
    \n    :set Value [\$fJParse true];\r\
    \n    :set (\$ParseArrayRet->([:len \$ParseArrayRet])) \$Value;\r\
    \n    :if (\$Jdebug) do={:put \"fJParseArray: Value=\"; :put \$Value;}\r\
    \n    \$fJSkipWhitespace;\r\
    \n    :if ([:pick \$JSONIn \$Jpos] = \",\") do={\r\
    \n      :set Jpos (\$Jpos + 1);\r\
    \n      \$fJSkipWhitespace;\r\
    \n    }\r\
    \n  }\r\
    \n  :set Jpos (\$Jpos + 1);\r\
    \n#  :if (\$Jdebug) do={:put \"ParseArrayRet: \"; :put \$ParseArrayRet}\r\
    \n  :return \$ParseArrayRet;\r\
    \n}}\r\
    \n\r\
    \n# -------------------------------- fJParseObject ---------------------------------------------------------------\r\
    \n:global fJParseObject\r\
    \n:if (!any \$fJParseObject) do={ :global fJParseObject do={\r\
    \n  :global Jpos;\r\
    \n  :global JSONIn;\r\
    \n  :global Jdebug;\r\
    \n  :global fJSkipWhitespace;\r\
    \n  :global fJParseString;\r\
    \n  :global fJParse;\r\
    \n# Syntax :local ParseObjectRet ({}) does not work in recursive call, use [:toarray \"\"] for empty array!!!\r\
    \n  :local ParseObjectRet [:toarray \"\"];\r\
    \n  :local Key;\r\
    \n  :local Value;\r\
    \n  :local ExitDo false;\r\
    \n \r\
    \n  \$fJSkipWhitespace;\r\
    \n  :while (\$Jpos < [:len \$JSONIn] and [:pick \$JSONIn \$Jpos]!=\"}\" and !\$ExitDo) do={\r\
    \n    :if ([:pick \$JSONIn \$Jpos]!=\"\\\"\") do={\r\
    \n      :put \"JParseFunctions.fJParseObject script: Err.Raise 8732. Expecting property name\";\r\
    \n      :set ExitDo true;\r\
    \n    } else={\r\
    \n      :set Jpos (\$Jpos + 1);\r\
    \n      :set Key [\$fJParseString];\r\
    \n      \$fJSkipWhitespace;\r\
    \n      :if ([:pick \$JSONIn \$Jpos] != \":\") do={\r\
    \n        :put \"JParseFunctions.fJParseObject script: Err.Raise 8732. Expecting : delimiter\";\r\
    \n        :set ExitDo true;\r\
    \n      } else={\r\
    \n        :set Jpos (\$Jpos + 1);\r\
    \n        :set Value [\$fJParse true];\r\
    \n        :set (\$ParseObjectRet->\$Key) \$Value;\r\
    \n        :if (\$Jdebug) do={:put \"fJParseObject: Key=\$Key Value=\"; :put \$Value;}\r\
    \n        \$fJSkipWhitespace;\r\
    \n        :if ([:pick \$JSONIn \$Jpos]=\",\") do={\r\
    \n          :set Jpos (\$Jpos + 1);\r\
    \n          \$fJSkipWhitespace;\r\
    \n        }\r\
    \n      }\r\
    \n    }\r\
    \n  }\r\
    \n  :set Jpos (\$Jpos + 1);\r\
    \n#  :if (\$Jdebug) do={:put \"ParseObjectRet: \"; :put \$ParseObjectRet;}\r\
    \n  :return \$ParseObjectRet;\r\
    \n}}\r\
    \n\r\
    \n# ------------------- fByteToEscapeChar ----------------------\r\
    \n:global fByteToEscapeChar;\r\
    \n:if (!any \$fByteToEscapeChar) do={ :global fByteToEscapeChar do={\r\
    \n#  :set \$1 [:tonum \$1];\r\
    \n  :return [[:parse \"(\\\"\\\\\$[:pick \"0123456789ABCDEF\" ((\$1 >> 4) & 0xF)]\$[:pick \"0123456789ABCDEF\" (\$1 & 0xF)]\\\")\"]];\r\
    \n}}\r\
    \n\r\
    \n# ------------------- fUnicodeToUTF8----------------------\r\
    \n:global fUnicodeToUTF8;\r\
    \n:if (!any \$fUnicodeToUTF8) do={ :global fUnicodeToUTF8 do={\r\
    \n  :global fByteToEscapeChar;\r\
    \n#  :local Ubytes [:tonum \$1];\r\
    \n  :local Nbyte;\r\
    \n  :local EscapeStr \"\";\r\
    \n\r\
    \n  :if (\$1 < 0x80) do={\r\
    \n    :set EscapeStr [\$fByteToEscapeChar \$1];\r\
    \n  } else={\r\
    \n    :if (\$1 < 0x800) do={\r\
    \n      :set Nbyte 2;\r\
    \n    } else={ \r\
    \n      :if (\$1 < 0x10000) do={\r\
    \n        :set Nbyte 3;\r\
    \n      } else={\r\
    \n        :if (\$1 < 0x20000) do={\r\
    \n          :set Nbyte 4;\r\
    \n        } else={\r\
    \n          :if (\$1 < 0x4000000) do={\r\
    \n            :set Nbyte 5;\r\
    \n          } else={\r\
    \n            :if (\$1 < 0x80000000) do={\r\
    \n              :set Nbyte 6;\r\
    \n            }\r\
    \n          }\r\
    \n        }\r\
    \n      }\r\
    \n    }\r\
    \n    :for i from=2 to=\$Nbyte do={\r\
    \n      :set EscapeStr ([\$fByteToEscapeChar (\$1 & 0x3F | 0x80)] . \$EscapeStr);\r\
    \n      :set \$1 (\$1 >> 6);\r\
    \n    }\r\
    \n    :set EscapeStr ([\$fByteToEscapeChar (((0xFF00 >> \$Nbyte) & 0xFF) | \$1)] . \$EscapeStr);\r\
    \n  }\r\
    \n  :return \$EscapeStr;\r\
    \n}}\r\
    \n\r\
    \n# ------------------- End JParseFunctions----------------------"
add dont-require-permissions=no name=pingCollector owner=admin policy=ftp,reboot,read,write,policy,test,password,sniff,sensitive,romon source="#------------- Ping Collector-----------------\r\
    \n\r\
    \n:local tempPingJsonString \"\";\r\
    \n:local pingHosts [:toarray \"\"];\r\
    \n:set (\$pingHosts->0) \"aws-us-east-1-ping.ispapp.co\";\r\
    \n:set (\$pingHosts->1) \"aws-us-west-1-ping.ispapp.co\";\r\
    \n:set (\$pingHosts->2) \"aws-eu-west-2-ping.ispapp.co\";\r\
    \n:set (\$pingHosts->3) \"aws-sa-east-1-ping.ispapp.co\";\r\
    \n\r\
    \n:for pc from=0 to=([:len \$pingHosts]-1) step=1 do={\r\
    \n  :put (\"pinging host \$pc \" . \$pingHosts->\$pc);\r\
    \n\r\
    \n  :if (\$pc > 0) do={\r\
    \n    :set tempPingJsonString (\$tempPingJsonString . \",\");\r\
    \n  }\r\
    \n\r\
    \n  :local avgRtt 0;\r\
    \n  :local minRtt 0;\r\
    \n  :local maxRtt 0;\r\
    \n  :local toPingDomain (\$pingHosts->\$pc);\r\
    \n  :local totalpingsreceived 0;\r\
    \n  :local totalpingssend 0; \r\
    \n\r\
    \n  :do {\r\
    \n    /tool flood-ping count=2 size=38 address=[:resolve \$toPingDomain] do={\r\
    \n      :set totalpingssend (\$\"received\" + \$totalpingssend);\r\
    \n      :set totalpingsreceived (\$\"received\" + \$totalpingsreceived);\r\
    \n      :set avgRtt (\$\"avg-rtt\" + \$avgRtt);\r\
    \n      :set minRtt (\$\"min-rtt\" + \$minRtt);\r\
    \n      :set maxRtt (\$\"max-rtt\" + \$maxRtt);\r\
    \n    }\r\
    \n  } on-error={\r\
    \n    :put (\"TOOL FLOOD_PING ERROR=====>>> \");\r\
    \n }\r\
    \n\r\
    \n:local calculateAvgRtt 0;\r\
    \n:local calculateMinRtt 0;\r\
    \n:local calculateMaxRtt 0;\r\
    \n:local percentage 0;\r\
    \n:local packetLoss 0;\r\
    \n\r\
    \n:if (\$totalpingssend != 0 ) do={\r\
    \n\r\
    \n  :set calculateAvgRtt ([:tostr (\$avgRtt / \$totalpingssend )]);\r\
    \n  #:put (\"avgRtt: \".\$calculateAvgRtt);\r\
    \n\r\
    \n  :set calculateMinRtt ([:tostr (\$minRtt / \$totalpingssend )]);\r\
    \n  #:put (\"minRtt: \".\$calculateMinRtt);\r\
    \n\r\
    \n  :set calculateMaxRtt ([:tostr (\$maxRtt / \$totalpingssend )]);\r\
    \n  #:put (\"maxRtt: \".\$calculateMaxRtt);\r\
    \n  \r\
    \n  :set percentage (((\$totalpingsreceived)*100) / (\$totalpingssend));\r\
    \n  \r\
    \n  :set packetLoss ((100 - \$percentage));\r\
    \n  #:put (\"packet loss: \". \$packetLoss);\r\
    \n\r\
    \n}\r\
    \n\r\
    \n:set tempPingJsonString (\$tempPingJsonString . \"{\\\"host\\\":\\\"\$toPingDomain\\\",\\\"avgRtt\\\":\$calculateAvgRtt,\\\"loss\\\":\$packetLoss,\\\"minRtt\\\":\$calculateMinRtt,\\\"maxRtt\\\":\$calculateMaxRtt}\");\r\
    \n\r\
    \n}\r\
    \n:global pingJsonString \$tempPingJsonString;\r\
    \n"
add dont-require-permissions=no name=lteCollector owner=admin policy=ftp,reboot,read,write,policy,test,password,sniff,sensitive,romon source="# if LTE logging is too verbose, disable it in your router's configuration\r\
    \n# /system logging print\r\
    \n# 4     lte       support\r\
    \n# /system logging disable 4\r\
    \n\r\
    \n:local Split do={\r\
    \n\r\
    \n  :local input \$1;\r\
    \n  :local delim \$2;\r\
    \n\r\
    \n  #:put \"Split()\";\r\
    \n  #:put \"INPUT: \$input\";\r\
    \n  #:put \"DELIMETER: \$delim\";\r\
    \n\r\
    \n  :local strElem;\r\
    \n  :local arr [:toarray \"\"];\r\
    \n  :local arrIndex 0;\r\
    \n\r\
    \n  :for c from=0 to=[:len \$input] do={\r\
    \n\r\
    \n    :local ch [:pick \$input \$c (\$c+1)];\r\
    \n    #:put \"ch \$c: \$ch\";\r\
    \n\r\
    \n    if (\$ch = \$delim) do={\r\
    \n\r\
    \n      if ([:len \$strElem] > 0) do={\r\
    \n        #:put \"found strElem: \$strElem\";\r\
    \n        :set (\$arr->\$arrIndex) \$strElem;\r\
    \n        :set arrIndex (\$arrIndex+1);\r\
    \n        :set strElem \"\";\r\
    \n      }\r\
    \n\r\
    \n    } else {\r\
    \n      :set strElem (\$strElem . \$ch);\r\
    \n    }\r\
    \n\r\
    \n  }\r\
    \n\r\
    \n  #:put \"last strElem: \$strElem\";\r\
    \n  :set (\$arr->\$arrIndex) \$strElem;\r\
    \n\r\
    \n  :return \$arr;\r\
    \n\r\
    \n}\r\
    \n\r\
    \n:global lteJsonString;\r\
    \n\r\
    \n#------------- Lte Collector-----------------\r\
    \n\r\
    \n:local lteArray;\r\
    \n:local lteCount 0;\r\
    \n\r\
    \n:foreach lteIfaceId in=[/interface lte find] do={\r\
    \n\r\
    \n  :local lteIfName ([/interface lte get \$lteIfaceId name]);\r\
    \n  :put \"lte interface name: \$lteIfName\";\r\
    \n\r\
    \n  # this is dead\r\
    \n  #:local lteIfDetail [/interface lte print detail as-value where name=\$lteIfName];\r\
    \n  #:put (\"lteIfDetail: \") . (\$lteIfDetail->0);\r\
    \n\r\
    \n  # send at-chat to the modem that you own and can remove all electricity from legally\r\
    \n  :local lteAt0 [:tostr  [/interface lte at-chat \$lteIfName input \"AT+CSQ\" as-value]];\r\
    \n  #:put \$lteAt0;\r\
    \n\r\
    \n  :local lteAt0Arr [\$Split \$lteAt0 \"\\n\"];\r\
    \n  #:put (\$lteAt0Arr->0);\r\
    \n\r\
    \n  :local snrArr [\$Split (\$lteAt0Arr->0) \" \"];\r\
    \n  # split the signal and the bit error rate by the comma\r\
    \n  :local sber [\$Split (\$snrArr->1) \",\"];\r\
    \n  :local signal (\$sber->0);\r\
    \n\r\
    \n  # convert the value to rssi\r\
    \n  # 2 equals -109\r\
    \n  # each value above 2 adds -2 and -109\r\
    \n  :local s (\$signal - 2);\r\
    \n  :set s (\$s * 2);\r\
    \n  :set signal (\$s + -109)\r\
    \n\r\
    \n  #:put \"signal: \$signal\";\r\
    \n\r\
    \n  :local lteAt1 [:tostr  [/interface lte at-chat \$lteIfName input \"AT+COPS\?\" as-value]];\r\
    \n  #:put \$lteAt1;\r\
    \n\r\
    \n  # if ERROR is in this string, then routeros' LTE is broken (happens often)\r\
    \n  :local mnc;\r\
    \n  if ([:find \$lteAt1 \"ERROR\"] > -1) do={\r\
    \n    :log info \"\$lteIfName not connected\";\r\
    \n  } else={\r\
    \n    # get the network name, at least the MNC (Mobile Network Code)\r\
    \n    :local mncArray [\$Split \$lteAt1 \",\"];\r\
    \n    # remove the first \" because \\\" cannot be passed to Split due to the routeros scripting language bug\r\
    \n    :set mnc [:pick (\$mncArray->2) 1 [:len (\$mncArray->2)]];\r\
    \n    # remove the last \"\r\
    \n    :set mnc [:pick \$mnc 0 ([:len \$mnc] - 1)];\r\
    \n    #:put \"MNC: \$mnc\";\r\
    \n  }\r\
    \n\r\
    \n  if (\$lteCount = 0) do={\r\
    \n    :set lteJsonString (\"{\\\"stations\\\":[],\\\"interface\\\":\\\"\$lteIfName\\\",\\\"ssid\\\":\\\"\$mnc\\\",\\\"signal0\\\":\$signal}\");\r\
    \n  } else={\r\
    \n    :set lteJsonString (\$lteJsonString . \",\" . \",{\\\"stations\\\":[],\\\"interface\\\":\\\"\$lteIfName\\\",\\\"ssid\\\":\\\"\$mnc\\\",\\\"signal0\\\":\$signal}\");\r\
    \n  }\r\
    \n\r\
    \n  :set lteCount (\$lteCount + 1);\r\
    \n\r\
    \n}\r\
    \n\r\
    \n#:log info (\"lteCollector\");\r\
    \n\r\
    \n# run this script again\r\
    \n:delay 10s;\r\
    \n:execute {/system script run lteCollector};"
add dont-require-permissions=yes name=collectors owner=admin policy=ftp,reboot,read,write,policy,test,password,sniff,sensitive,romon source=":global updateRetries;\r\
    \n:global lteJsonString;\r\
    \n:global login;\r\
    \n:global collectorsRunning;\r\
    \nif (\$collectorsRunning = true) do={\r\
    \n  # the argument here is that this should be a counter, but really each collector should be a script ran in a do/catch block and this be a boolean until someone edits the root script and ruins that.\r\
    \n  #:error \"collectors is already running\";\r\
    \n}\r\
    \n:set collectorsRunning true;\r\
    \n:global pingJsonString;\r\
    \n\r\
    \n#------------- Interface Collector-----------------\r\
    \n\r\
    \n:local ifaceName;\r\
    \n:local rxBytes 0;\r\
    \n:local rxPackets 0;\r\
    \n:local rxErrors 0;\r\
    \n:local rxDrops 0;\r\
    \n:local txBytes 0;\r\
    \n:local txPackets 0;\r\
    \n:local txErrors 0;\r\
    \n:local txDrops 0;\r\
    \n:local cChanges 0;\r\
    \n:local ifaceDataArray;\r\
    \n:local totalInterface;\r\
    \n\r\
    \n:set totalInterface ([/interface print as-value count-only]);\r\
    \n\r\
    \n:local interfaceCounter 0;\r\
    \n\r\
    \n:foreach iface in=[/interface find] do={\r\
    \n\r\
    \n  :set interfaceCounter (\$interfaceCounter + 1);\r\
    \n\r\
    \n  :if ( [:len \$iface] != 0 ) do={\r\
    \n\r\
    \n    :set ifaceName [/interface get \$iface name];\r\
    \n\r\
    \n    :if ( [:len \$ifaceName] !=0 ) do={\r\
    \n\r\
    \n      :local rxBytesVal [/interface get \$iface rx-byte];\r\
    \n      if ([:len \$rxBytesVal]>0) do={\r\
    \n        :set rxBytes \$rxBytesVal;\r\
    \n      }\r\
    \n      :local txBytesVal [/interface get \$iface tx-byte];\r\
    \n      if ([:len \$txBytesVal]>0) do={\r\
    \n        :set txBytes \$txBytesVal;\r\
    \n      }\r\
    \n\r\
    \n      :local rxPacketsVal [/interface get \$iface rx-packet];\r\
    \n      if ([:len \$rxPacketsVal]>0) do={\r\
    \n        :set rxPackets \$rxPacketsVal;\r\
    \n      }\r\
    \n      :local txPacketsVal [/interface get \$iface tx-packet];\r\
    \n      if ([:len \$txPacketsVal]>0) do={\r\
    \n        :set txPackets \$txPacketsVal\r\
    \n      }\r\
    \n\r\
    \n      :local rxErrorsVal [/interface get \$iface rx-error];\r\
    \n      if ([:len \$rxErrorsVal]>0) do={\r\
    \n        :set rxErrors \$rxErrorsVal;\r\
    \n      }\r\
    \n      :local txErrorsVal [/interface get \$iface tx-error];\r\
    \n      if ([:len \$txErrorsVal]>0) do={\r\
    \n        :set txErrors \$txErrorsVal\r\
    \n      }\r\
    \n\r\
    \n      :local rxDropsVal [/interface get \$iface rx-drop];\r\
    \n      if ([:len \$rxDropsVal]>0) do={\r\
    \n        :set rxDrops \$rxDropsVal;\r\
    \n      }\r\
    \n      :local txDropsVal [/interface get \$iface tx-drop];\r\
    \n      if ([:len \$txDropsVal]>0) do={\r\
    \n        :set txDrops \$txDropsVal;\r\
    \n      }\r\
    \n\r\
    \n      :local cChanges [/interface get \$iface link-downs];\r\
    \n\r\
    \n      :if (\$interfaceCounter != \$totalInterface) do={\r\
    \n        :local ifaceData \"{\\\"if\\\":\\\"\$ifaceName\\\", \\\"recBytes\\\":\$rxBytes, \\\"recPackets\\\":\$rxPackets, \\\"recErrors\\\":\$rxErrors, \\\"recDrops\\\":\$rxDrops, \\\"sentBytes\\\":\$txBytes, \\\"sentPacke\
    ts\\\":\$txPackets, \\\"sentErrors\\\":\$txErrors, \\\"sentDrops\\\":\$txDrops, \\\"carrierChanges\\\":\$cChanges},\";\r\
    \n        :set ifaceDataArray (\$ifaceDataArray.\$ifaceData);\r\
    \n      }\r\
    \n      :if (\$interfaceCounter = \$totalInterface) do={\r\
    \n        :local ifaceData \"{\\\"if\\\":\\\"\$ifaceName\\\", \\\"recBytes\\\":\$rxBytes, \\\"recPackets\\\":\$rxPackets, \\\"recErrors\\\":\$rxErrors, \\\"recDrops\\\":\$rxDrops, \\\"sentBytes\\\":\$txBytes, \\\"sentPacke\
    ts\\\":\$txPackets, \\\"sentErrors\\\":\$txErrors, \\\"sentDrops\\\":\$txDrops, \\\"carrierChanges\\\":\$cChanges}\";\r\
    \n        :set ifaceDataArray (\$ifaceDataArray.\$ifaceData);\r\
    \n      }\r\
    \n\r\
    \n    }\r\
    \n  }\r\
    \n}\r\
    \n\r\
    \n#------------- Wap Collector-----------------\r\
    \n\r\
    \n:local wapArray;\r\
    \n:local wapCount 0;\r\
    \n\r\
    \n:foreach wIfaceId in=[/interface wireless find] do={\r\
    \n\r\
    \n  :local wIfName ([/interface wireless get \$wIfaceId name]);\r\
    \n  :local wIfSsid ([/interface wireless get \$wIfaceId ssid]);\r\
    \n\r\
    \n  if (\$wIfSsid = \"ispapp-\$login\") do={\r\
    \n    # do not send collector data for the ispapp-\$login ssid\r\
    \n    :put \"not sending collector data for ssid: ispapp-\$login\";\r\
    \n  } else={\r\
    \n\r\
    \n  # average the noise for the interface based on each connected station\r\
    \n  :local wIfNoise 0;\r\
    \n  :local wIfSig0 0;\r\
    \n  :local wIfSig1 0;\r\
    \n\r\
    \n  #:put (\"wireless interface \$wIfName ssid: \$wIfSsid\");\r\
    \n\r\
    \n  :local staJson;\r\
    \n  :local staCount 0;\r\
    \n\r\
    \n  :foreach wStaId in=[/interface wireless registration-table find where interface=\$wIfName] do={\r\
    \n\r\
    \n    :local wStaMac ([/interface wireless registration-table get \$wStaId mac-address]);\r\
    \n\r\
    \n    :local wStaRssi ([/interface wireless registration-table get \$wStaId signal-strength]);\r\
    \n    :set wStaRssi ([:pick \$wStaRssi 0 [:find \$wStaRssi \"dBm\"]]);\r\
    \n\r\
    \n    :local wStaNoise ([/interface wireless registration-table get \$wStaId signal-to-noise]);\r\
    \n    #:put \"noise \$wStaNoise\"\r\
    \n\r\
    \n    :local wStaSig0 ([/interface wireless registration-table get \$wStaId signal-strength-ch0]);\r\
    \n    #:put \"sig0 \$wStaSig0\"\r\
    \n\r\
    \n    :local wStaSig1 ([/interface wireless registration-table get \$wStaId signal-strength-ch1]);\r\
    \n    #:put \"sig1 \$wStaSig1\"\r\
    \n\r\
    \n    :set wIfNoise (\$wIfNoise + \$wStaNoise);\r\
    \n    :set wIfSig0 (\$wIfSig0 + \$wStaSig0);\r\
    \n    :set wIfSig1 (\$wIfSig1 + \$wStaSig1);\r\
    \n\r\
    \n    :local wStaIfBytes ([/interface wireless registration-table get \$wStaId bytes]);\r\
    \n    :local wStaIfSentBytes ([:pick \$wStaIfBytes 0 [:find \$wStaIfBytes \",\"]]);\r\
    \n    :local wStaIfRecBytes ([:pick \$wStaIfBytes 0 [:find \$wStaIfBytes \",\"]]);\r\
    \n\r\
    \n    :local wStaDhcpName ([/ip dhcp-server lease find where mac-address=\$wStaMac]);\r\
    \n\r\
    \n    if (\$wStaDhcpName) do={\r\
    \n      :set wStaDhcpName ([/ip dhcp-server lease get \$wStaDhcpName host-name]);\r\
    \n    } else={\r\
    \n      :set wStaDhcpName \"\";\r\
    \n    }\r\
    \n\r\
    \n    #:put (\"wireless station: \$wStaMac \$wStaRssi\");\r\
    \n\r\
    \n    :local newSta;\r\
    \n\r\
    \n    if (\$staCount = 0) do={\r\
    \n      :set newSta \"{\\\"mac\\\":\\\"\$wStaMac\\\",\\\"rssi\\\":\$wStaRssi,\\\"sentBytes\\\":\$wStaIfSentBytes,\\\"recBytes\\\":\$wStaIfRecBytes,\\\"info\\\":\\\"\$wStaDhcpName\\\"}\";\r\
    \n    } else={\r\
    \n      :set newSta \",{\\\"mac\\\":\\\"\$wStaMac\\\",\\\"rssi\\\":\$wStaRssi,\\\"sentBytes\\\":\$wStaIfSentBytes,\\\"recBytes\\\":\$wStaIfRecBytes,\\\"info\\\":\\\"\$wStaDhcpName\\\"}\";\r\
    \n    }\r\
    \n\r\
    \n    :set staJson (\$staJson.\$newSta);\r\
    \n\r\
    \n    :set staCount (\$staCount + 1);\r\
    \n\r\
    \n  }\r\
    \n\r\
    \n  :if (\$staCount > 0) do={\r\
    \n    #:put \"averaging noise, \$wIfNoise / \$staCount\";\r\
    \n    :set wIfNoise (-\$wIfNoise / \$staCount);\r\
    \n  }\r\
    \n\r\
    \n  #:put \"if noise: \$wIfNoise\";\r\
    \n\r\
    \n  :if (\$wIfSig0 != 0) do={\r\
    \n    #:put \"averaging sig0, \$wIfSig0 / \$staCount\";\r\
    \n    :set wIfSig0 (\$wIfSig0 / \$staCount);\r\
    \n  }\r\
    \n\r\
    \n  :if (\$wIfSig1 != 0) do={\r\
    \n    #:put \"averaging sig0, \$wIfSig1 / \$staCount\";\r\
    \n    :set wIfSig1 (\$wIfSig1 / \$staCount);\r\
    \n  }\r\
    \n\r\
    \n  :local newWapIf;\r\
    \n\r\
    \n  if (\$wapCount = 0) do={\r\
    \n    :set newWapIf \"{\\\"stations\\\":[\$staJson],\\\"interface\\\":\\\"\$wIfName\\\",\\\"ssid\\\":\\\"\$wIfSsid\\\",\\\"noise\\\":\$wIfNoise,\\\"signal0\\\":\$wIfSig0,\\\"signal1\\\":\$wIfSig1}\";\r\
    \n  } else={\r\
    \n    :set newWapIf \",{\\\"stations\\\":[\$staJson],\\\"interface\\\":\\\"\$wIfName\\\",\\\"ssid\\\":\\\"\$wIfSsid\\\",\\\"noise\\\":\$wIfNoise,\\\"signal0\\\":\$wIfSig0,\\\"signal1\\\":\$wIfSig1}\";\r\
    \n  }\r\
    \n\r\
    \n  :set wapCount (\$wapCount + 1);\r\
    \n\r\
    \n  :set wapArray (\$wapArray.\$newWapIf);\r\
    \n\r\
    \n  }\r\
    \n\r\
    \n}\r\
    \n\r\
    \n#------------- caps-man Collector-----------------\r\
    \n\r\
    \n:foreach wIfaceId in=[/caps-man interface find] do={\r\
    \n\r\
    \n  :local wIfName ([/caps-man interface get \$wIfaceId name]);\r\
    \n  :local wIfConfName ([/caps-man interface get \$wIfName configuration]);\r\
    \n  :local wIfSsid ([/caps-man configuration get \$wIfConfName ssid]);\r\
    \n\r\
    \n  # average the noise for the interface based on each connected station\r\
    \n  :local wIfNoise 0;\r\
    \n  :local wIfSig0 0;\r\
    \n  :local wIfSig1 0;\r\
    \n\r\
    \n  #:put (\"caps-man interface \$wIfName ssid: \$wIfSsid\");\r\
    \n\r\
    \n  :local staJson;\r\
    \n  :local staCount 0;\r\
    \n\r\
    \n  :foreach wStaId in=[/caps-man registration-table find where interface=\$wIfName] do={\r\
    \n\r\
    \n    :local wStaMac ([/caps-man registration-table get \$wStaId mac-address]);\r\
    \n    #:put \"station mac: \$wStaMac\";\r\
    \n\r\
    \n    :local wStaRssi ([/caps-man registration-table get \$wStaId rx-signal]);\r\
    \n\r\
    \n    :local wStaNoise 0;\r\
    \n    #:put \"noise \$wStaNoise\"\r\
    \n\r\
    \n    :local wStaSig0 ([/caps-man registration-table get \$wStaId rx-signal]);\r\
    \n    #:put \"sig0 \$wStaSig0\"\r\
    \n\r\
    \n    :local wStaSig1 ([/caps-man registration-table get \$wStaId tx-signal]);\r\
    \n    #:put \"sig1 \$wStaSig1\"\r\
    \n\r\
    \n    :set wIfNoise (\$wIfNoise + \$wStaNoise);\r\
    \n    :set wIfSig0 (\$wIfSig0 + \$wStaSig0);\r\
    \n    :set wIfSig1 (\$wIfSig1 + \$wStaSig1);\r\
    \n\r\
    \n    :local wStaIfBytes ([/caps-man registration-table get \$wStaId bytes]);\r\
    \n    :local wStaIfSentBytes ([:pick \$wStaIfBytes 0 [:find \$wStaIfBytes \",\"]]);\r\
    \n    :local wStaIfRecBytes ([:pick \$wStaIfBytes 0 [:find \$wStaIfBytes \",\"]]);\r\
    \n\r\
    \n    :local wStaDhcpName ([/ip dhcp-server lease find where mac-address=\$wStaMac]);\r\
    \n\r\
    \n    if (\$wStaDhcpName) do={\r\
    \n      :set wStaDhcpName ([/ip dhcp-server lease get \$wStaDhcpName host-name]);\r\
    \n    } else={\r\
    \n      :set wStaDhcpName \"\";\r\
    \n    }\r\
    \n\r\
    \n    #:put (\"caps-man station: \$wStaMac \$wStaRssi\");\r\
    \n    #:put (\"bytes: \$wStaIfSentBytes \$wStaIfRecBytes\");\r\
    \n    #:put (\"dhcp lease host-name: \$wStaDhcpName\");\r\
    \n\r\
    \n    :local newSta;\r\
    \n\r\
    \n    if (\$staCount = 0) do={\r\
    \n      :set newSta \"{\\\"mac\\\":\\\"\$wStaMac\\\",\\\"rssi\\\":\$wStaRssi,\\\"sentBytes\\\":\$wStaIfSentBytes,\\\"recBytes\\\":\$wStaIfRecBytes,\\\"info\\\":\\\"\$wStaDhcpName\\\"}\";\r\
    \n    } else={\r\
    \n      :set newSta \",{\\\"mac\\\":\\\"\$wStaMac\\\",\\\"rssi\\\":\$wStaRssi,\\\"sentBytes\\\":\$wStaIfSentBytes,\\\"recBytes\\\":\$wStaIfRecBytes,\\\"info\\\":\\\"\$wStaDhcpName\\\"}\";\r\
    \n    }\r\
    \n\r\
    \n    :set staJson (\$staJson.\$newSta);\r\
    \n\r\
    \n    :set staCount (\$staCount + 1);\r\
    \n\r\
    \n  }\r\
    \n\r\
    \n  :if (\$staCount > 0) do={\r\
    \n    #:put \"averaging noise, \$wIfNoise / \$staCount\";\r\
    \n    :set wIfNoise (-\$wIfNoise / \$staCount);\r\
    \n  }\r\
    \n\r\
    \n  #:put \"if noise: \$wIfNoise\";\r\
    \n\r\
    \n  :if (\$wIfSig0 != 0) do={\r\
    \n    #:put \"averaging sig0, \$wIfSig0 / \$staCount\";\r\
    \n    :set wIfSig0 (\$wIfSig0 / \$staCount);\r\
    \n  }\r\
    \n\r\
    \n  :if (\$wIfSig1 != 0) do={\r\
    \n    #:put \"averaging sig0, \$wIfSig1 / \$staCount\";\r\
    \n    :set wIfSig1 (\$wIfSig1 / \$staCount);\r\
    \n  }\r\
    \n\r\
    \n  :local newWapIf;\r\
    \n\r\
    \n  if (\$wapCount = 0) do={\r\
    \n    :set newWapIf \"{\\\"stations\\\":[\$staJson],\\\"interface\\\":\\\"\$wIfName\\\",\\\"ssid\\\":\\\"\$wIfSsid\\\",\\\"noise\\\":\$wIfNoise,\\\"signal0\\\":\$wIfSig0,\\\"signal1\\\":\$wIfSig1}\";\r\
    \n  } else={\r\
    \n    :set newWapIf \",{\\\"stations\\\":[\$staJson],\\\"interface\\\":\\\"\$wIfName\\\",\\\"ssid\\\":\\\"\$wIfSsid\\\",\\\"noise\\\":\$wIfNoise,\\\"signal0\\\":\$wIfSig0,\\\"signal1\\\":\$wIfSig1}\";\r\
    \n  }\r\
    \n\r\
    \n  :set wapCount (\$wapCount + 1);\r\
    \n\r\
    \n  :set wapArray (\$wapArray.\$newWapIf);\r\
    \n\r\
    \n}\r\
    \n\r\
    \n#----- lte -----\r\
    \n\r\
    \n  # add the lte interfaces to the wapArray json if they exist\r\
    \n  if ([:len \$lteJsonString] > 0) do={\r\
    \n    if ([:len \$wapArray] = 0) do={\r\
    \n      :set wapArray (\$lteJsonString);\r\
    \n    } else={\r\
    \n      :set wapArray (\$wapArray . \",\" . \$lteJsonString);\r\
    \n    }\r\
    \n  }\r\
    \n\r\
    \n  #:put \$wapArray;\r\
    \n\r\
    \n#------------- System Collector-----------------\r\
    \n\r\
    \n:global cpuLoad;\r\
    \nif ([:len \$cpuLoad] = 0) do={\r\
    \n  :set cpuLoad 0;\r\
    \n}\r\
    \n\r\
    \n#Memory\r\
    \n\r\
    \n:local totalMem 0;\r\
    \n:local freeMem 0;\r\
    \n:local memBuffers 0;\r\
    \n:local cachedMem 0;\r\
    \n:set totalMem ([/system resource get total-memory])\r\
    \n:set freeMem ([/system resource get free-memory])\r\
    \n:set memBuffers 0\r\
    \n:set cachedMem ([/ip route cache get cache-size])\r\
    \n\r\
    \n#Disks\r\
    \n\r\
    \n:local diskDataArray \"\";\r\
    \n:local totalDisks;\r\
    \n:set totalDisks ([/disk print as-value count-only]);\r\
    \n\r\
    \n:local disksCounter 0;\r\
    \n:foreach disk in=[/disk find] do={\r\
    \n\r\
    \n  :local diskName \"\";\r\
    \n  :local diskFree 0;\r\
    \n  :local diskSize 0;\r\
    \n  :local diskUsed 0;\r\
    \n\r\
    \n  :if (\$totalDisks != 0) do={\r\
    \n    :set diskName [/disk get \$disksCounter name];\r\
    \n    :set diskFree [/disk get \$disksCounter free];\r\
    \n    :set diskSize [/disk get \$disksCounter size];\r\
    \n    :set diskUsed ((\$diskSize - \$diskFree));\r\
    \n  }\r\
    \n\r\
    \n  :if (\$totalDisks = 1) do={\r\
    \n    :local diskData \"{\\\"mount\\\":\\\"\$diskName\\\",\\\"used\\\":\$diskUsed,\\\"avail\\\":\$diskFree}\";\r\
    \n    :set diskDataArray (\$diskDataArray.\$diskData);\r\
    \n  }\r\
    \n  :if (\$totalDisks > 1) do={\r\
    \n    :if (\$disksCounter != \$totalDisks) do={\r\
    \n      :local diskData \"{\\\"mount\\\":\\\"\$diskName\\\",\\\"used\\\":\$diskUsed,\\\"avail\\\":\$diskFree},\";\r\
    \n      :set diskDataArray (\$diskDataArray.\$diskData);\r\
    \n    }\r\
    \n    :if (\$disksCounter = \$totalDisks) do={\r\
    \n      :local diskData \"{\\\"mount\\\":\\\"\$diskName\\\",\\\"used\\\":\$diskUsed,\\\"avail\\\":\$diskFree}\";\r\
    \n      :set diskDataArray (\$diskDataArray.\$diskData);\r\
    \n    }\r\
    \n  }  \r\
    \n}\r\
    \n\r\
    \n:local processCount [:len [/system script job find]];\r\
    \n:local systemArray \"{\\\"load\\\":{\\\"one\\\":\$cpuLoad,\\\"five\\\":\$cpuLoad,\\\"fifteen\\\":\$cpuLoad,\\\"processCount\\\":\$processCount},\\\"memory\\\":{\\\"total\\\":\$totalMem,\\\"free\\\":\$freeMem,\\\"buffers\
    \\\":\$memBuffers,\\\"cached\\\":\$cachedMem},\\\"disks\\\":[\$diskDataArray]}\";\r\
    \n\r\
    \n:global collectUpDataVal \"{\\\"ping\\\":[\$pingJsonString],\\\"wap\\\":[\$wapArray], \\\"interface\\\":[\$ifaceDataArray],\\\"system\\\":\$systemArray,\\\"counter\\\":[{\\\"name\\\":\\\"update retries\\\",\\\"point\\\":\
    \$updateRetries}]}\";\r\
    \n:set collectorsRunning false;"
add dont-require-permissions=no name=config owner=admin policy=ftp,reboot,read,write,policy,test,password,sniff,sensitive,romon source="# enable the scheduler so this keeps trying\
    \_until authenticated\r\
    \n/system scheduler enable config\r\
    \n:log info (\"config script start\");\r\
    \n\r\
    \n# Url for Collect\r\
    \n:global topUrl;\r\
    \n\r\
    \n# Key for Collect\r\
    \n:global topKey;\r\
    \n\r\
    \n# client info for Collect\r\
    \n:global topClientInfo;\r\
    \n\r\
    \n:global login;\r\
    \n:global urlEncodeFunct;\r\
    \n\r\

    \n\r\
    \n# Unix timestamp to number\r\
    \n:local fncBuildDate do={\r\
    \n:local months [:toarray \"Jan,Feb,Mar,Apr,May,Jun,Jul,Aug,Sep,Oct,Nov,Dec\"];\r\
    \n:local jd;\r\
    \n:local M [:pick \$1 0 3];\r\
    \n:local D [:pick \$1 4 6];\r\
    \n:local Y [:pick \$1 7 11];\r\
    \n:for x from=0 to=([:len \$months] - 1) do={\r\
    \n\r\
    \n  :if ([:tostr [:pick \$months \$x]] = \$M) do={:set M (\$x + 1) } \r\
    \n}\r\
    \n:if ( \$M = 1 || \$M = 2) do={\r\
    \n    :set Y (\$Y-1);\r\
    \n    :set M (\$M+12);\r\
    \n}\r\
    \n:local A (\$Y/100);\r\
    \n:local B (\$A/4);\r\
    \n:local C (2-\$A+\$B);\r\
    \n:local E (((\$Y+4716) * 36525)/100);\r\
    \n:local F ((306001*(\$M+1))/10000);\r\
    \n:local jd (\$C+\$D+\$E+\$F-1525);\r\
    \n:return \$jd;\r\
    \n}\r\
    \n\r\
    \n:local buildTime [/system resource get build-time];\r\
    \n\r\
    \n:local buildDate;\r\
    \n:local buildTimeValue;\r\
    \n:local parseDate [:find \$buildTime \" \"];\r\
    \n:if ([:len \$parseDate] != 0) do={\r\
    \n    :set buildDate [:pick \$buildTime 0 11];\r\
    \n    :set buildTimeValue [:pick \$buildTime 12 20];\r\
    \n}\r\
    \n\r\
    \n:local nowDate [\$fncBuildDate \$buildDate];\r\
    \n\r\
    \n:local currentTime \$buildTimeValue;\r\
    \n\r\
    \n:local days (\$nowDate - 2440587);\r\
    \n:local hour [:pick \$currentTime 0 2];\r\
    \n:local minute [:pick \$currentTime 3 5];\r\
    \n:local second [:pick \$currentTime 6 8];\r\
    \n\r\
    \n:local osbuildate [((((\$days * 86400) + (\$hour * 3600)) + (\$minute * 60)) + \$second)];\r\
    \n\r\
    \n:local osversion [/system package get 0 version];\r\
    \n:local os [/system package get 0 name];\r\
    \n:local hardwaremake [/system resource get platform];\r\
    \n:local hardwaremodel [/system resource get board-name];\r\
    \n:local cpu [/system resource get cpu];\r\
    \n\r\
    \n:local hwUrlValCollectData (\"{\\\"login\\\":\\\"\$login\\\",\\\"key\\\":\\\"\$topKey\\\",\\\"clientInfo\\\":\\\"\$topClientInfo\\\", \\\"osVersion\\\":\\\"\$osversion\\\", \
    \\\"hardwareMake\\\":\\\"\$hardwaremake\\\",\\\"hardwareModel\\\":\\\"\$hardwaremodel\\\",
    \\\"hardwareCpuInfo\\\":\\\"\$cpu\\\",\\\"os\\\":\\\"\$os\\\",\\\"osBuildDate\\\":\$osbuildate,\\\"fw\\\":\\\"\$topClientInfo\\\"}\");\r\
    \n\r\
    \n:local collectorsUrl \"config\";\r\
    \n\r\
    \n:local fetchHardwareBootUrlFuct [\$urlEncodeFunct currentUrlVal=\$topUrl urlVal=\$collectorsUrl];\r\
    \n\r\
    \n:put \"\$hwUrlValCollectData\";\r\
    \n\r\
    \n:local configSendData;\r\
    \n:do { \r\
    \n  :set configSendData [/tool fetch mode=https http-method=post http-header-field=\"cache-control: no-cache, content-type: application/json\" http-data=\"\$hwUrlValCollectDat\
    a\" url=\$fetchHardwareBootUrlFuct  as-value output=user duration=4]\r\
    \n  :put (\"FETCH CONFIG HARDWARE FUNCT OK =======>>>\");\r\
    \n} on-error={\r\
    \n  :put (\"FETCH CONFIG HARDWARE FUNCT ERROR =======>>>\");\r\
    \n}\r\
    \n\r\
    \n:delay 1;\r\
    \n\r\
    \n:local setConfig 0;\r\
    \n:local host;\r\
    \n\r\
    \n:put \"\\nconfigSendData (config request response before parsing):\\n\";\r\
    \n:put \$configSendData;\r\
    \n:put \"\\n\";\r\
    \n\r\
    \n# make sure there was a non empty response\r\
    \n# and that Err was not the first three characters, indicating an inability to parse\r\
    \nif ([:len \$configSendData] != 0 && [:find \$configSendData \"Err.Raise 8732\"] != 0) do={\r\
    \n\r\
    \n  :local jstr;\r\
    \n\r\
    \n  :set jstr [\$configSendData];\r\
    \n  /system script run \"JParseFunctions\";\r\
    \n  global JSONIn\r\
    \n  global JParseOut;\r\
    \n  global fJParse;\r\
    \n\r\
    \n  # Parse data\r\
    \n  :set JSONIn (\$jstr->\"data\");\r\
    \n  :set JParseOut [\$fJParse];\r\
    \n\r\
    \n  :set host (\$JParseOut->\"host\");\r\
    \n  :local jsonError (\$JParseOut->\"error\");\r\
    \n\r\
    \n  if ( [:len \$host] != 0 ) do={\r\
    \n\r\
    \n    # set outageIntervalSeconds and updateIntervalSeconds\r\
    \n    :global outageIntervalSeconds (num(\$host->\"outageIntervalSeconds\"));\r\
    \n    :global updateIntervalSeconds (num(\$host->\"updateIntervalSeconds\"));\r\
    \n\r\
    \n    # check if lastConfigChangeTsMs in the response\r\
    \n    # is larger than the last configuration application\r\
    \n\r\
    \n    :global lastConfigChangeTsMs;\r\
    \n\r\
    \n    :local lcf (\$host->\"lastConfigChangeTsMs\");\r\
    \n    :put \"response's lastConfigChangeTsMs: \$lcf\";\r\
    \n    :put \"current lastConfigChangeTsMs: \$lastConfigChangeTsMs\";\r\
    \n\r\
    \n    if (\$lcf != \$lastConfigChangeTsMs) do={\r\
    \n      :put \"new configuration must be applied\";\r\
    \n\r\
    \n      #set the value to that sent by the server\r\
    \n      :set lastConfigChangeTsMs \$lcf;\r\
    \n\r\
    \n      :set setConfig 1;\r\
    \n\r\
    \n    }\r\
    \n\r\
    \n    # the config response is authenticated, disable the scheduler\r\
    \n    # and enable cmdGetDataFromApi which is the update request loop\r\
    \n    # otherwise, keep making config requests so that after the host\r\
    \n    # is added and not an unknown host, it will actually make a config request\r\
    \n    # and get the configuration it should have\r\
    \n\r\
    \n    /system scheduler disable config;\r\
    \n    /system scheduler enable cmdGetDataFromApi;\r\
    \n    /system script run cmdGetDataFromApi;\r\
    \n\r\
    \n    :put \"setConfig: \$setConfig\";\r\
    \n\r\
    \n  } else={\r\
    \n\r\
    \n    # there was an error in the response\r\
    \n    :put (\"config request responded with an error: \" . \$jsonError);\r\
    \n\r\
    \n    if ([:find \$jsonError \"invalid login\"] > -1) do={\r\
    \n      :put \"invalid login, running globalScript to make sure login is set correctly\";\r\
    \n      /system script run globalScript;\r\
    \n    }\r\
    \n\r\
    \n  }\r\
    \n\r\
    \n} else={\r\
    \n\r\
    \n  # there was a parsing error, the scheduler will continue repeating config requests and \$setConfig will not equal 1\r\
    \n  :put \"JSON parsing error with config request, config scheduler will continue retrying\";\r\
    \n\r\
    \n}\r\
    \n\r\
    \nif (\$setConfig = 1) do={\r\
    \n\r\
    \n  :put \"applying configuration, setConfig=1\";\r\
    \n\r\
    \n  :local lenval (\$host->\"wirelessConfigs\");\r\
    \n\r\
    \n  :local hostkey (\$host->\"key\");\r\
    \n  #:put \"hostkey: \$hostkey\";\r\
    \n  :do {\r\
    \n    # if the password is blank, set it to the hostkey\r\
    \n    /password new-password=\"\$hostkey\" confirm-new-password=\"\$hostkey\" old-password=\"\";\r\
    \n    # if the password was able to be modified, then disable ip services that are not required\r\
    \n    /ip service disable ftp\r\
    \n    /ip service disable api\r\
    \n    /ip service disable telnet\r\
    \n    /ip service disable www\r\
    \n    /ip service disable www-ssl\r\
    \n  } on-error={\r\
    \n    :put \"incorrect old-password, must be changed manually\";\r\
    \n  }\r\
    \n\r\
    \n# disable ip services that are not needed\r\
    \n\r\
    \n  :local hostname (\$host->\"name\");\r\
    \n  :put \"hostname: \$hostname\";\r\
    \n\r\
    \n  :put (\"Host Name ==>>>\" . \$hostname);\r\
    \n  if ([:len \$hostname] != 0) do={\r\
    \n    :put (\"System identity changed.\");\r\
    \n    :do { /system identity set name=\$hostname }\r\
    \n  }\r\
    \n  if ([:len \$hostname] = 0) do={\r\
    \n    :put (\"System identity not added!!!\");\r\
    \n  }\r\
    \n\r\
    \n  :local mode;\r\
    \n  :local channelwith;\r\
    \n  :local wifibeaconint;\r\
    \n\r\
    \n  :set mode (\$host->\"wirelessMode\");\r\
    \n  :set channelwith (\$host->\"wirelessChannel\");\r\
    \n  #:set wifibeaconint (\$host->\"wirelessBeaconInt\");\r\
    \n\r\
    \n  :local wifiModeCtrl \"0\";\r\
    \n  :if ([:len [/interface wireless find ]]>0) do={\r\
    \n    :set wifiModeCtrl \"1\";\r\
    \n  }\r\
    \n\r\
    \n\r\
    \n    :global wanIP;\r\
    \n    :put \"wanIP: \$wanIP\";\r\
    \n\r\
    \n    :put \"wireless mode: \$mode with WAN interface: \$wanport\";\r\
    \n\r\
    \n     # add bridge\r\
    \n     if ([:len [/interface bridge find name=\"ispapp-wifi\"]] = 0) do={\r\
    \n       /interface bridge add name=\"ispapp-wifi\";\r\
    \n      :put \"created first ispapp-wifi bridge\";\r\
    \n      :do {\r\
    \n         /interface wireless security-profiles remove ispapp-hidden;\r\
    \n       } on-error={\r\
    \n       }\r\
    \n       # make the wpa2 key asdfasdf + the first 10 letters of the host key to ensure it is between 8 and 64 characters long\r\
    \n       :local asdf [:pick \"\$hostkey\" 1 10];\r\
    \n       /interface wireless security-profiles add name=ispapp-hidden mode=dynamic-keys authentication-types=wpa2-psk wpa2-pre-shared-key=\"asdfasdf\$asdf\";\r\
    \n    } else={\r\
    \n      :put \"ispapp-wifi bridge is already created\";\r\
    \n    }\r\
    \n\r\
    \n    # remove existing ispapp requirements for ap_router mode\r\
    \n    # dhcp server, ip pool, ip address, nat rule\r\
    \n    :do {\r\
    \n      /ip firewall nat remove [find comment=ispapp-wifi];\r\
    \n    } on-error={\r\
    \n    }\r\
    \n     :do {\r\
    \n      /ip dhcp-server remove [find interface=ispapp-wifi];\r\
    \n    } on-error={\r\
    \n    }\r\
    \n     :do {\r\
    \n      /ip dhcp-server network remove [find gateway=10.10.0.1];\r\
    \n    } on-error={\r\
    \n    }\r\
    \n     :do {\r\
    \n      /ip dhcp-server network remove [find gateway=10.11.0.1];\r\
    \n    }\r\
    \n     :do {\r\
    \n      /ip pool remove ispapp-wifi-pool;\r\
    \n    } on-error={\r\
    \n    }\r\
    \n     :do {\r\
    \n      /ip address remove [find interface=ispapp-wifi];\r\
    \n    } on-error={\r\
    \n    }\r\
    \n\r\
    \n     if (\$mode = \"ap_router\") do={\r\
    \n     # mode is ap_router and the wanIP is not in the subnet to add, this maintains ispapp connectivity and allows manual configuration via the webshell\r\
    \n\r\
    \n        :put \"WAN <> ispapp-wifi with NAT\";\r\
    \n        :local ipPre \"10.10\";\r\
    \n        if ([:find \$wanIP \$ipPre] = 0) do={\r\
    \n          :set ipPre \"10.11\";\r\
    \n        }\r\
    \n        /ip address add interface=ispapp-wifi address=(\$ipPre . \".0.1/16\");\r\
    \n        /ip pool add ranges=(\$ipPre . \".0.10-10.10.254.254\") name=ispapp-wifi-pool;\r\
    \n        /ip dhcp-server network add address=(\$ipPre . \".0.0/16\") dns-server=8.8.8.8,8.8.4.4 gateway=(\$ipPre . \".0.1\")\r\
    \n        /ip dhcp-server add interface=ispapp-wifi address-pool=ispapp-wifi-pool disabled=no;\r\
    \n        /ip firewall nat add action=masquerade chain=srcnat comment=ispapp-wifi\r\
    \n\r\
    \n     } else={\r\
    \n\r\
    \n       :put \"WAN <> ispapp-wifi as BRIDGE\";\r\
    \n       :put \"\\nYOU NEED TO ADD THE WAN PORT TO THE 'ispapp-wifi' BRIDGE\\n/interface bridge port add bridge=ispapp-wifi interface=wan0\\n\";\r\
    \n\r\
    \n     }\r\
    \n\r\
    \n     # remove existing vaps and bridge ports\r\
    \n     :foreach wIfaceId in=[/interface wireless find] do={\r\
    \n\r\
    \n        :local wIfName ([/interface wireless get \$wIfaceId name]);\r\
    \n        :local wIfSsid ([/interface wireless get \$wIfaceId ssid]);\r\
    \n        :local isIspappIf ([:find \$wIfName \"ispapp-\"]);\r\
    \n\r\
    \n        if (\$isIspappIf = 0) do={\r\
    \n          :put \"deleting ispapp interface: \$wIfName\";\r\
    \n          /interface bridge port remove [find interface=\$wIfName];\r\
    \n          /interface wireless remove \$wIfName;\r\
    \n          /interface wireless security-profiles remove \$wIfName;\r\
    \n        } else={\r\
    \n          # if a non virtual ap is broadcasting the Mikrotik ssid, hide the ssid and set it to ispapp-\$login\r\
    \n          :put \"non virtual ap ssid: \$wIfSsid\";\r\
    \n          if (\$wIfSsid = \"MikroTik\") do={\r\
    \n            :put \"if ssid=Mikrotik, set to ispapp-\$login\";\r\
    \n            /interface wireless set ssid=\"ispapp-\$login\" hide-ssid=\"yes\" security-profile=ispapp-hidden \$wIfName;\r\
    \n          }\r\
    \n\r\
    \n        }\r\
    \n\r\
    \n      }\r\
    \n\r\
    \n  if (\$wifiModeCtrl = \"1\") do={\r\
    \n    # this device has wireless interfaces\r\
    \n    :put \"device has wireless hardware\";\r\
    \n\r\
    \n    :local i;\r\
    \n    :for i from=0 to=([:len \"\$lenval\"]-1) do={\r\
    \n      # this is each configured ssid, there can be many\r\
    \n      \r\
    \n      :local vlanmode \"use-tag\";\r\
    \n\r\
    \n      :local authenticationtypes (\$lenval->\$i->\"encType\");\r\
    \n      :local encryptionKey (\$lenval->\$i->\"encKey\");\r\
    \n      :local ssid (\$lenval->\$i->\"ssid\");\r\
    \n      #:local vlanid (\$lenval->\$i->\"vlanId\");\r\
    \n      :local vlanid 0;\r\
    \n      :local defaultforward (\$lenval->\$i->\"clientIsolation\");\r\
    \n      :local preamblemode (\$lenval->\$i->\"sp\");\r\
    \n      :local dotw (\$lenval->\$i->\"dotw\");\r\
    \n\r\
    \n      if (\$authenticationtypes = \"psk\") do={\r\
    \n        :set authenticationtypes \"wpa2-psk\";\r\
    \n      }\r\
    \n      if (\$authenticationtypes = \"psk2\") do={\r\
    \n        :set authenticationtypes \"wpa2-psk\";\r\
    \n      }\r\
    \n      if (\$authenticationtypes = \"sae\") do={\r\
    \n        :set authenticationtypes \"wpa2-psk\";\r\
    \n      }\r\
    \n      if (\$authenticationtypes = \"sae-mixed\") do={\r\
    \n        :set authenticationtypes \"wpa2-psk\";\r\
    \n      }\r\
    \n      if (\$authenticationtypes = \"owe\") do={\r\
    \n        :set authenticationtypes \"wpa2-psk\";\r\
    \n      }\r\
    \n\r\
    \n      if (\$vlanid = 0) do={\r\
    \n        :set vlanid  1;\r\
    \n        :set vlanmode \"no-tag\"\r\
    \n      }\r\
    \n\r\
    \n      # change json values of configuration parameters to what routeros expects\r\
    \n      if (\$mode = \"sta\") do={\r\
    \n        :set mode \"station\";\r\
    \n      }\r\
    \n      if (\$defaultforward = \"true\") do={\r\
    \n        :set defaultforward \"yes\";\r\
    \n      }\r\
    \n      if (\$defaultforward = \"false\") do={\r\
    \n        :set defaultforward \"no\";\r\
    \n      }\r\
    \n      if (\$channelwith != \"auto\") do={\r\
    \n        :set channelwith \"20mhz\";\r\
    \n      }\r\
    \n      if (\$preamblemode = \"true\") do={\r\
    \n        :set preamblemode \"long\";\r\
    \n      }\r\
    \n      if (\$preamblemode = \"false\") do={\r\
    \n        :set preamblemode \"short\";\r\
    \n      }\r\
    \n\r\
    \n      :put \"\\nconfiguring wireless network \$ssid\";\r\
    \n      :put (\"index ==>\" . \$i);\r\
    \n      :put (\"hostname==>\" . \$hostname);\r\
    \n      :put (\"authtype==>\" . \$authenticationtypes);\r\
    \n      :put (\"enckey==>\" . \$encryptionKey);\r\
    \n      :put (\"ssid==>\" . \$ssid);\r\
    \n      :put (\"vlanid==>\" . \$vlanid);\r\
    \n      :put (\"chwidth==>\" . \$channelwith);\r\
    \n      :put (\"forwardmode==>\" . \$defaultforward);\r\
    \n      :put (\"preamblemode==>\" . \$preamblemode);\r\
    \n\r\
    \n      # for each wireless interface, create a vap\r\
    \n      :foreach wIfaceId in=[/interface wireless find] do={\r\
    \n\r\
    \n        :local wIfName ([/interface wireless get \$wIfaceId name]);\r\
    \n        :local wIfType ([/interface wireless get \$wIfaceId interface-type]);\r\
    \n\r\
    \n        :put \"wifi interface: \$wIfName, type: \$wIfType\";\r\
    \n\r\
    \n        /interface wireless enable \$wIfName;\r\
    \n        /interface wireless set \$wIfName mode=ap-bridge\r\
    \n\r\
    \n        if (\$wIfType != \"virtual\") do={\r\
    \n          /interface wireless security-profiles add name=\"ispapp-\$ssid-\$wIfName\" mode=dynamic-keys authentication-types=\"\$authenticationtypes\" wpa2-pre-shared-key=\"\
    \$encryptionKey\"\r\
    \n          /interface wireless add master-interface=\"\$wIfName\" ssid=\"\$ssid\" name=\"ispapp-\$ssid-\$wIfName\" security-profile=\"ispapp-\$ssid-\$wIfName\" wireless-proto\
    col=802.11 frequency=auto mode=ap-bridge;\r\
    \n          /interface wireless enable \"ispapp-\$ssid-\$wIfName\";\r\
    \n          /interface bridge port add bridge=ispapp-wifi interface=\"ispapp-\$ssid-\$wIfName\";\r\
    \n        }\r\
    \n\r\
    \n      }\r\
    \n\r\
    \n    }\r\
    \n  }\r\
    \n\r\
    \n}"
add dont-require-permissions=no name=base64EncodeFunctions owner=admin policy=ftp,reboot,read,write,policy,test,password,sniff,sensitive,romon source="# ------------------- Base64EncodeFunct ---------\
    -------------\r\
    \n\r\
    \n:global base64EncodeFunct do={ \r\
    \n\r\
    \n  #:put \"base64EncodeFunct arg b=\$stringVal\"\r\
    \n\r\
    \n  :local charToDec [:toarray \"\"];\r\
    \n# newline character is needed\r\
    \n:set (\$charToDec->\"\\n\") \"10\";\r\
    \n:set (\$charToDec->\" \") \"32\";\r\
    \n:set (\$charToDec->\"!\") \"33\";\r\
    \n:set (\$charToDec->\"#\") \"35\";\r\
    \n:set (\$charToDec->\"\\\$\") \"36\";\r\
    \n:set (\$charToDec->\"%\") \"37\";\r\
    \n:set (\$charToDec->\"&\") \"38\";\r\
    \n:set (\$charToDec->\"'\") \"39\";\r\
    \n:set (\$charToDec->\"(\") \"40\";\r\
    \n:set (\$charToDec->\")\") \"41\";\r\
    \n:set (\$charToDec->\"*\") \"42\";\r\
    \n:set (\$charToDec->\"+\") \"43\";\r\
    \n:set (\$charToDec->\",\") \"44\";\r\
    \n:set (\$charToDec->\"-\") \"45\";\r\
    \n:set (\$charToDec->\".\") \"46\";\r\
    \n:set (\$charToDec->\"/\") \"47\";\r\
    \n:set (\$charToDec->\"0\") \"48\";\r\
    \n:set (\$charToDec->\"1\") \"49\";\r\
    \n:set (\$charToDec->\"2\") \"50\";\r\
    \n:set (\$charToDec->\"3\") \"51\";\r\
    \n:set (\$charToDec->\"4\") \"52\";\r\
    \n:set (\$charToDec->\"5\") \"53\";\r\
    \n:set (\$charToDec->\"6\") \"54\";\r\
    \n:set (\$charToDec->\"7\") \"55\";\r\
    \n:set (\$charToDec->\"8\") \"56\";\r\
    \n:set (\$charToDec->\"9\") \"57\";\r\
    \n:set (\$charToDec->\":\") \"58\";\r\
    \n:set (\$charToDec->\";\") \"59\";\r\
    \n:set (\$charToDec->\"<\") \"60\";\r\
    \n:set (\$charToDec->\"=\") \"61\";\r\
    \n:set (\$charToDec->\">\") \"62\";\r\
    \n:set (\$charToDec->\"\?\") \"63\";\r\
    \n:set (\$charToDec->\"@\") \"64\";\r\
    \n:set (\$charToDec->\"A\") \"65\";\r\
    \n:set (\$charToDec->\"B\") \"66\";\r\
    \n:set (\$charToDec->\"C\") \"67\";\r\
    \n:set (\$charToDec->\"D\") \"68\";\r\
    \n:set (\$charToDec->\"E\") \"69\";\r\
    \n:set (\$charToDec->\"F\") \"70\";\r\
    \n:set (\$charToDec->\"G\") \"71\";\r\
    \n:set (\$charToDec->\"H\") \"72\";\r\
    \n:set (\$charToDec->\"I\") \"73\";\r\
    \n:set (\$charToDec->\"J\") \"74\";\r\
    \n:set (\$charToDec->\"K\") \"75\";\r\
    \n:set (\$charToDec->\"L\") \"76\";\r\
    \n:set (\$charToDec->\"M\") \"77\";\r\
    \n:set (\$charToDec->\"N\") \"78\";\r\
    \n:set (\$charToDec->\"O\") \"79\";\r\
    \n:set (\$charToDec->\"P\") \"80\";\r\
    \n:set (\$charToDec->\"Q\") \"81\";\r\
    \n:set (\$charToDec->\"R\") \"82\";\r\
    \n:set (\$charToDec->\"S\") \"83\";\r\
    \n:set (\$charToDec->\"T\") \"84\";\r\
    \n:set (\$charToDec->\"U\") \"85\";\r\
    \n:set (\$charToDec->\"V\") \"86\";\r\
    \n:set (\$charToDec->\"W\") \"87\";\r\
    \n:set (\$charToDec->\"X\") \"88\";\r\
    \n:set (\$charToDec->\"Y\") \"89\";\r\
    \n:set (\$charToDec->\"Z\") \"90\";\r\
    \n:set (\$charToDec->\"[\") \"91\";\r\
    \n:set (\$charToDec->\"]\") \"93\";\r\
    \n:set (\$charToDec->\"^\") \"94\";\r\
    \n:set (\$charToDec->\"_\") \"95\";\r\
    \n:set (\$charToDec->\"`\") \"96\";\r\
    \n:set (\$charToDec->\"a\") \"97\";\r\
    \n:set (\$charToDec->\"b\") \"98\";\r\
    \n:set (\$charToDec->\"c\") \"99\";\r\
    \n:set (\$charToDec->\"d\") \"100\";\r\
    \n:set (\$charToDec->\"e\") \"101\";\r\
    \n:set (\$charToDec->\"f\") \"102\";\r\
    \n:set (\$charToDec->\"g\") \"103\";\r\
    \n:set (\$charToDec->\"h\") \"104\";\r\
    \n:set (\$charToDec->\"i\") \"105\";\r\
    \n:set (\$charToDec->\"j\") \"106\";\r\
    \n:set (\$charToDec->\"k\") \"107\";\r\
    \n:set (\$charToDec->\"l\") \"108\";\r\
    \n:set (\$charToDec->\"m\") \"109\";\r\
    \n:set (\$charToDec->\"n\") \"110\";\r\
    \n:set (\$charToDec->\"o\") \"111\";\r\
    \n:set (\$charToDec->\"p\") \"112\";\r\
    \n:set (\$charToDec->\"q\") \"113\";\r\
    \n:set (\$charToDec->\"r\") \"114\";\r\
    \n:set (\$charToDec->\"s\") \"115\";\r\
    \n:set (\$charToDec->\"t\") \"116\";\r\
    \n:set (\$charToDec->\"u\") \"117\";\r\
    \n:set (\$charToDec->\"v\") \"118\";\r\
    \n:set (\$charToDec->\"w\") \"119\";\r\
    \n:set (\$charToDec->\"x\") \"120\";\r\
    \n:set (\$charToDec->\"y\") \"121\";\r\
    \n:set (\$charToDec->\"z\") \"122\";\r\
    \n:set (\$charToDec->\"{\") \"123\";\r\
    \n:set (\$charToDec->\"|\") \"124\";\r\
    \n:set (\$charToDec->\"}\") \"125\";\r\
    \n:set (\$charToDec->\"~\") \"126\";\r\
    \n\r\
    \n  :local base64Chars [:toarray \"\"];\r\
    \n:set (\$base64Chars->\"0\") \"A\";\r\
    \n:set (\$base64Chars->\"1\") \"B\";\r\
    \n:set (\$base64Chars->\"2\") \"C\";\r\
    \n:set (\$base64Chars->\"3\") \"D\";\r\
    \n:set (\$base64Chars->\"4\") \"E\";\r\
    \n:set (\$base64Chars->\"5\") \"F\";\r\
    \n:set (\$base64Chars->\"6\") \"G\";\r\
    \n:set (\$base64Chars->\"7\") \"H\";\r\
    \n:set (\$base64Chars->\"8\") \"I\";\r\
    \n:set (\$base64Chars->\"9\") \"J\";\r\
    \n:set (\$base64Chars->\"10\") \"K\";\r\
    \n:set (\$base64Chars->\"11\") \"L\";\r\
    \n:set (\$base64Chars->\"12\") \"M\";\r\
    \n:set (\$base64Chars->\"13\") \"N\";\r\
    \n:set (\$base64Chars->\"14\") \"O\";\r\
    \n:set (\$base64Chars->\"15\") \"P\";\r\
    \n:set (\$base64Chars->\"16\") \"Q\";\r\
    \n:set (\$base64Chars->\"17\") \"R\";\r\
    \n:set (\$base64Chars->\"18\") \"S\";\r\
    \n:set (\$base64Chars->\"19\") \"T\";\r\
    \n:set (\$base64Chars->\"20\") \"U\";\r\
    \n:set (\$base64Chars->\"21\") \"V\";\r\
    \n:set (\$base64Chars->\"22\") \"W\";\r\
    \n:set (\$base64Chars->\"23\") \"X\";\r\
    \n:set (\$base64Chars->\"24\") \"Y\";\r\
    \n:set (\$base64Chars->\"25\") \"Z\";\r\
    \n:set (\$base64Chars->\"26\") \"a\";\r\
    \n:set (\$base64Chars->\"27\") \"b\";\r\
    \n:set (\$base64Chars->\"28\") \"c\";\r\
    \n:set (\$base64Chars->\"29\") \"d\";\r\
    \n:set (\$base64Chars->\"30\") \"e\";\r\
    \n:set (\$base64Chars->\"31\") \"f\";\r\
    \n:set (\$base64Chars->\"32\") \"g\";\r\
    \n:set (\$base64Chars->\"33\") \"h\";\r\
    \n:set (\$base64Chars->\"34\") \"i\";\r\
    \n:set (\$base64Chars->\"35\") \"j\";\r\
    \n:set (\$base64Chars->\"36\") \"k\";\r\
    \n:set (\$base64Chars->\"37\") \"l\";\r\
    \n:set (\$base64Chars->\"38\") \"m\";\r\
    \n:set (\$base64Chars->\"39\") \"n\";\r\
    \n:set (\$base64Chars->\"40\") \"o\";\r\
    \n:set (\$base64Chars->\"41\") \"p\";\r\
    \n:set (\$base64Chars->\"42\") \"q\";\r\
    \n:set (\$base64Chars->\"43\") \"r\";\r\
    \n:set (\$base64Chars->\"44\") \"s\";\r\
    \n:set (\$base64Chars->\"45\") \"t\";\r\
    \n:set (\$base64Chars->\"46\") \"u\";\r\
    \n:set (\$base64Chars->\"47\") \"v\";\r\
    \n:set (\$base64Chars->\"48\") \"w\";\r\
    \n:set (\$base64Chars->\"49\") \"x\";\r\
    \n:set (\$base64Chars->\"50\") \"y\";\r\
    \n:set (\$base64Chars->\"51\") \"z\";\r\
    \n:set (\$base64Chars->\"52\") \"0\";\r\
    \n:set (\$base64Chars->\"53\") \"1\";\r\
    \n:set (\$base64Chars->\"54\") \"2\";\r\
    \n:set (\$base64Chars->\"55\") \"3\";\r\
    \n:set (\$base64Chars->\"56\") \"4\";\r\
    \n:set (\$base64Chars->\"57\") \"5\";\r\
    \n:set (\$base64Chars->\"58\") \"6\";\r\
    \n:set (\$base64Chars->\"59\") \"7\";\r\
    \n:set (\$base64Chars->\"60\") \"8\";\r\
    \n:set (\$base64Chars->\"61\") \"9\";\r\
    \n:set (\$base64Chars->\"62\") \"+\";\r\
    \n:set (\$base64Chars->\"63\") \"/\";\r\
    \n\r\
    \n#:put \$charToDec;\r\
    \n#:put \$base64Chars;\r\
    \n\r\
    \n  :local rr \"\"; \r\
    \n  :local p \"\";\r\
    \n  :local s \"\";\r\
    \n  :local cLenForString ([:len \$stringVal]);\r\
    \n  :local cModVal ( \$cLenForString % 3);\r\
    \n  :local stringLen ([:len \$stringVal]);\r\
    \n  :local returnVal;\r\
    \n\r\
    \n  if (\$cLenForString > 0) do={\r\
    \n    :local startEncode 0;\r\
    \n\r\
    \n    :if (\$cModVal > 0) do={\r\
    \n       for val from=(\$cModVal+1) to=3 do={\r\
    \n          :set p (\$p.\"=\"); \r\
    \n          :set s (\$s.\"0\"); \r\
    \n          :set cModVal (\$cModVal + 1);\r\
    \n        }\r\
    \n    }\r\
    \n\r\
    \n    :local firstIndex 0;\r\
    \n    :while ( \$firstIndex < \$stringLen ) do={\r\
    \n\r\
    \n        if ((\$cModVal > 0) && ((((\$cModVal / 3) *4) % 76) = 0) ) do={\r\
    \n          :set rr (\$rr . \"\\ r \\ n\");\r\
    \n        }\r\
    \n\r\
    \n        :local charVal1 ([:pick \"\$stringVal\" \$firstIndex (\$firstIndex + 1)]);\r\
    \n        :local charVal2 ([:pick \$stringVal (\$firstIndex + 1) (\$firstIndex + 2)]);\r\
    \n        :local charVal3 ([:pick \$stringVal (\$firstIndex+2) (\$firstIndex + 3)]);\r\
    \n\r\
    \n        :local n1Shift ([:tonum (\$charToDec->\$charVal1)] << 16);\r\
    \n        :local n2Shift ([:tonum (\$charToDec->\$charVal2)] << 8);\r\
    \n        :local n3Shift [:tonum (\$charToDec->\$charVal3)];\r\
    \n\r\
    \n        :local mergeShift ((\$n1Shift +\$n2Shift) + \$n3Shift);\r\
    \n\r\
    \n        :local n \$mergeShift;\r\
    \n        :set n ([:tonum \$n]);\r\
    \n\r\
    \n        :local n1 (n >>> 18);\r\
    \n\r\
    \n        :local n2 (n >>> 12);\r\
    \n\r\
    \n        :local n3 (n >>> 6);\r\
    \n          \r\
    \n        :local arrayN [:toarray \"\" ];\r\
    \n        :set arrayN ( \$arrayN, (n1 & 63));\r\
    \n        :set arrayN ( \$arrayN, (n2 & 63));\r\
    \n        :set arrayN ( \$arrayN, (n3 & 63));\r\
    \n        :set arrayN ( \$arrayN, (n & 63));\r\
    \n\r\
    \n        :set n (\$arrayN);\r\
    \n\r\
    \n        :local n1Val ([:pick \$n 0]);\r\
    \n        :set n1Val ([:tostr \$n1Val]);\r\
    \n\r\
    \n        :local n2Val ([:pick \$n 1]);\r\
    \n        :set n2Val ([:tostr \$n2Val]);\r\
    \n\r\
    \n        :local n3Val ([:pick \$n 2]);\r\
    \n        :set n3Val ([:tostr \$n3Val]);\r\
    \n\r\
    \n        :local n4Val ([:pick \$n 3]);\r\
    \n        :set n4Val ([:tostr \$n4Val]);\r\
    \n    \r\
    \n        :set rr (\$rr . ((\$base64Chars->\$n1Val) . (\$base64Chars->\$n2Val) . (\$base64Chars->\$n3Val) . (\$base64Chars->\$n4Val)));\r\
    \n\r\
    \n        :set firstIndex (\$firstIndex + 3);\r\
    \n    }\r\
    \n\r\
    \n    # checks for errors\r\
    \n    :do {\r\
    \n\r\
    \n      :local rLen ([:len \$rr]);\r\
    \n      :local pLen ([:len \$p]);\r\
    \n\r\
    \n      :set returnVal ([:pick \"\$rr\" 0 (\$rLen - \$pLen)]);\r\
    \n      :set returnVal (\$returnVal . \$p);\r\
    \n      :set startEncode 1;\r\
    \n      :return \$returnVal;\r\
    \n     \r\
    \n    } on-error={\r\
    \n      :set returnVal (\"Error: Base64 encode error.\");\r\
    \n      :return \$returnVal;\r\
    \n    }\r\
    \n\r\
    \n  } else={\r\
    \n    :set returnVal (\"Error: Base64 encode error, likely an empty value.\");\r\
    \n    :return \$returnVal;\r\
    \n  }\r\
    \n  \r\
    \n}"
add dont-require-permissions=no name=initMultipleScript owner=admin policy=ftp,reboot,read,write,policy,test,password,sniff,sensitive,romon source="/system scheduler disable cmdGe\
    tDataFromApi\r\
    \n:global updateRetries 0;\r\
    \n/system scheduler disable collectors;\r\
    \n\r\
    \n:do {\r\
    \n  /system script run JParseFunctions;\r\
    \n} on-error={\r\
    \n  :log info (\"JParseFunctions INIT SCRIPT ERROR =======>>>\");\r\
    \n}\r\
    \n:do {\r\
    \n  /system script run base64EncodeFunctions;\r\
    \n  :put (\"base64EncodeFunctions INIT SCRIPT OK =======>>>\");\r\
    \n} on-error={\r\
    \n  :log info (\"base64EncodeFunctions INIT SCRIPT ERROR =======>>>\");\r\
    \n}\r\
    \n:do {\r\
    \n   /system script run globalScript;\r\
    \n} on-error={\r\
    \n  :log info (\"globalScript INIT SCRIPT ERROR =======>>>\");\r\
    \n}\r\
    \n:do {\r\
    \n  # this runs without a scheduler, because LTE modems still use serial communications\r\
    \n  /system script run lteCollector;\r\
    \n} on-error={\r\
    \n  :log info (\"lteCollector INIT SCRIPT ERROR =======>>>\");\r\
    \n}\r\
    \n:do {\r\
    \n  # this runs without a scheduler, because the routeros scheduler wastes too many cpu cycles\r\
    \n  /system script run avgCpuCollector;\r\
    \n} on-error={\r\
    \n  :log info (\"avgCpuCollector INIT SCRIPT ERROR =======>>>\");\r\
    \n}\r\
    \n:do {\r\
    \n     /system script run config;\r\
    \n  :put (\"config INIT SCRIPT OK =======>>>\");\r\
    \n} on-error={\r\
    \n  :log info (\"config INIT SCRIPT ERROR =======>>>\");\r\
    \n}\r\
    \n/system scheduler enable cmdGetDataFromApi\r\
    \n/system scheduler enable collectors\r\
    \n/system scheduler enable initMultipleScript"
add dont-require-permissions=no name=cmdGetDataFromApi owner=admin policy=ftp,reboot,read,write,policy,test,password,sniff,sensitive,romon source=":local sameScriptRunningCount [:len [/system/script/j\
    ob/find script=cmdGetDataFromApi]];\r\
    \n\r\
    \nif (\$sameScriptRunningCount > 1) do={\r\
    \n  :error (\"cmdGetDataFromApi script already running \" . \$sameScriptRunningCount . \" times\");\r\
    \n}\r\
    \n\r\
    \n:local Split do={\r\
    \n\r\
    \n  :local input \$1;\r\
    \n  :local delim \$2;\r\
    \n\r\
    \n  #:put \"Split()\\nINPUT:\\n\$input\\n\\nDELIMETER:\\n\$delim\\n\\n\";\r\
    \n\r\
    \n  :local strElem;\r\
    \n  :local arr [:toarray \"\"];\r\
    \n  :local arrIndex 0;\r\
    \n\r\
    \n  :for c from=0 to=[:len \$input] do={\r\
    \n\r\
    \n    :local ch [:pick \$input \$c (\$c+1)];\r\
    \n    #:put \"ch \$c: \$ch\";\r\
    \n\r\
    \n    if (\$ch = \$delim) do={\r\
    \n\r\
    \n      if ([:len \$strElem] > 0) do={\r\
    \n        #:put \"found strElem: \$strElem\";\r\
    \n        :set (\$arr->\$arrIndex) \$strElem;\r\
    \n        :set arrIndex (\$arrIndex+1);\r\
    \n        :set strElem \"\";\r\
    \n      }\r\
    \n\r\
    \n    } else {\r\
    \n      :set strElem (\$strElem . \$ch);\r\
    \n    }\r\
    \n\r\
    \n  }\r\
    \n\r\
    \n  #:put \"last strElem: \$strElem\";\r\
    \n  :set (\$arr->\$arrIndex) \$strElem;\r\
    \n\r\
    \n  :return \$arr;\r\
    \n\r\
    \n}\r\
    \n\r\
    \n# CMD and fastUpdate\r\
    \n\r\
    \n:global updateRetries;\r\
    \n\r\
    \n:global topClientInfo;\r\
    \n:global topUrl;\r\
    \n:global topKey;\r\
    \n:global login;\r\
    \n:global urlEncodeFunct;\r\
    \n\r\
    \n:global collectUpDataVal;\r\
    \n:if ([:len \$collectUpDataVal] = 0) do={\r\
    \n  :set collectUpDataVal \"{}\";\r\
    \n}\r\
    \n\r\
    \n# WAN Port IP Address\r\
    \n:global wanIP;\r\
    \n:do {\r\
    \n\r\
    \n  :local gatewayStatus ([:tostr [/ip route get [:pick [find dst-address=0.0.0.0/0 active=yes] 0] gateway-status]]);\r\
    \n\r\
    \n  #:put \"gatewayStatus: \$gatewayStatus\";\r\
    \n\r\
    \n  # split the gateway status into\r\
    \n  # IP/NM, reachable status, via, interface\r\
    \n  :local gwStatusArray [\$Split \$gatewayStatus \" \"];\r\
    \n  :put \"\$gwStatusArray\";\r\
    \n\r\
    \n  # get ip address and netmask as IP/Netmask\r\
    \n  :local tempIpv4String [/ip address get [:pick [/ip address find interface=(\$gwStatusArray->3)] 0] address];\r\
    \n  # split by /\r\
    \n  :local wanIpv4Arr [\$Split \$tempIpv4String \"/\"];\r\
    \n  # set the wan ip\r\
    \n  :set wanIP (\$wanIpv4Arr->0);\r\
    \n\r\
    \n} on-error={\r\
    \n  :set wanIP \"\";\r\
    \n  #:log info (\"Error finding WAN IP.\");\r\
    \n}\r\
    \n\r\
    \n:local upSeconds 0;\r\
    \n# All this is just to convert XwYdHH:MM:SS to seconds.\r\
    \n:local upTime [/system resource get uptime];\r\
    \n\r\
    \n:local weeks 0;\r\
    \nif (([:find \$upTime \"w\"]) > 0 ) do={\r\
    \n  :set weeks ([:pick \$upTime 0 ([:find \$upTime \"w\"])]);\r\
    \n  :set upTime [:pick \$upTime ([:find \$upTime \"w\"]+1) [:len \$upTime]];\r\
    \n}\r\
    \n:local days 0;\r\
    \nif (([:find \$upTime \"d\"]) > 0 ) do={\r\
    \n  :set days ([:pick \$upTime 0 [:find \$upTime \"d\"]]);\r\
    \n  :set upTime [:pick \$upTime ([:find \$upTime \"d\"]+1) [:len \$upTime]];\r\
    \n}\r\
    \n\r\
    \n:local hours [:pick \$upTime 0 [:find \$upTime \":\"]];\r\
    \n:set upTime [:pick \$upTime ([:find \$upTime \":\"]+1) [:len \$upTime]];\r\
    \n\r\
    \n:local minutes [:pick \$upTime 0 [:find \$upTime \":\"]];\r\
    \n:set upTime [:pick \$upTime ([:find \$upTime \":\"]+1) [:len \$upTime]];\r\
    \n\r\
    \n:local upSecondVal 0;\r\
    \n:set upSecondVal \$upTime;\r\
    \n\r\
    \n:set upSeconds value=[:tostr ((\$weeks*604800)+(\$days*86400)+(\$hours*3600)+(\$minutes*60)+\$upSecondVal)];\r\
    \n\r\
    \n:local upSecondsVal value=[:tostr \$upSeconds];\r\
    \n\r\
    \n# version data\r\
    \n:local mymodel [/system resource get board-name];\r\
    \n:local myversion [/system package get 0 version];\r\
    \n\r\
    \n:local collectUpData \"{\\\"collectors\\\":\$collectUpDataVal,\\\"login\\\":\\\"\$login\\\",\\\"key\\\":\\\"\$topKey\\\",\\\"clientInfo\\\":\\\"\$topClientInfo\\\", \\\"osVersion\\\":\\\"RB\$mym\
    odel-\$myversion\\\", \\\"wanIp\\\":\\\"\$wanIP\\\",\\\"uptime\\\":\$upSeconds}\";\r\
    \n\r\
    \n:put \"sending data to /update\";\r\
    \n:put (\"\$collectUpData\");\r\
    \n\r\
    \n:local collectorsUrl \"update\";\r\
    \n\r\
    \n:local mergeUpdateCollectorsUrl ([\$urlEncodeFunct currentUrlVal=\$topUrl urlVal=\$collectorsUrl]);\r\
    \n\r\
    \n:local updateResponse;\r\
    \n:local cmdsArrayLenVal;\r\
    \n\r\
    \n:global neededRetry;\r\
    \n\r\
    \n# use a duration less than the minimum update request interval with fastUpdate=true (2s)\r\
    \n:do {\r\
    \n    :set updateResponse ([/tool fetch mode=https http-method=post http-header-field=\"cache-control: no-cache, content-type: application/json\" http-data=\"\$collectUpData\" url=\$mergeUpdateCol\
    lectorsUrl as-value output=user duration=1500ms]);\r\
    \n    :put (\"updateResponse\");\r\
    \n    :put (\$updateResponse);\r\
    \n\r\
    \n    if (\$neededRetry = true) do={\r\
    \n      /system scheduler enable cmdGetDataFromApi;\r\
    \n      :set neededRetry false;\r\
    \n    }\r\
    \n\r\
    \n} on-error={\r\
    \n  :log info (\"Error with /update request to ISPApp.\");\r\
    \n  :set updateRetries (\$updateRetries + 1);\r\
    \n  :set neededRetry true;\r\
    \n  /system scheduler disable cmdGetDataFromApi;\r\
    \n  :execute {/system script run cmdGetDataFromApi};\r\
    \n  :error \"error with /update request\";\r\
    \n}\r\
    \n\r\
    \n  :put \"parsing json\";\r\
    \n  \r\
    \n  /system script run \"JParseFunctions\";\r\
    \n\r\
    \n  :global JSONIn;\r\
    \n  :global JParseOut;\r\
    \n  :global fJParse;\r\
    \n    \r\
    \n  :set JSONIn (\$updateResponse->\"data\");\r\
    \n  :set JParseOut [\$fJParse];\r\
    \n\r\
    \n  :put \$JParseOut;\r\
    \n    \r\
    \n  if ( [:len \$JParseOut] != 0 ) do={\r\
    \n\r\
    \n    :local jsonError (\$JParseOut->\"error\");\r\
    \n\r\
    \n    :local fwStatus (\$JParseOut->\"fwStatus\");\r\
    \n    if (\$fwStatus = \"pending\") do={\r\
    \n      :global upgrading;\r\
    \n\r\
    \n      if (\$upgrading = true) do={\r\
    \n        :error \"another upgrade is running\";\r\
    \n      }\r\
    \n      :set upgrading true;\r\
    \n\r\
    \n      :put \"server requested upgrade\";\r\
    \n      :local upgradeDomain [\$Split \$topUrl \":\"];\r\
    \n      :local upgradeUrl (\$upgradeDomain->0 . \":\" . \$upgradeDomain->1 . \"/host_fw\?login=\" . \$login . \"&key=\" . \$topKey);\r\
    \n      :put \$upgradeUrl;\r\
    \n      :do {\r\
    \n        /tool fetch url=\"\$upgradeUrl\" output=file dst-path=\"ispapp-upgrade.rsc\";\r\
    \n      } on-error={\r\
    \n        :set upgrading false;\r\
    \n        :error \"error downloading upgrade file\";\r\
    \n      }\r\
    \n      /import \"/ispapp-upgrade.rsc\";\r\
    \n      :set upgrading false;\r\
    \n    }\r\
    \n\r\
    \n    :local rebootval (\$JParseOut->\"reboot\");\r\
    \n\r\
    \n    :put \"rebootval: \$rebootval\";\r\
    \n\r\
    \n    if ( \$rebootval = \"1\" ) do={\r\
    \n      :global booturl \"config\?login=\$login&key=\$topKey\"\r\
    \n      :global mergeBootUrlFuct;\r\
    \n      :set mergeBootUrlFuct [\$urlEncodeFunct currentUrlVal=\$topUrl urlVal=\$booturl];\r\
    \n\r\
    \n      :log info \"Reboot\";\r\
    \n      /system reboot;\r\
    \n\r\
    \n    } else={\r\
    \n\r\
    \n      # check if lastConfigChangeTsMs is different\r\
    \n      :global lastConfigChangeTsMs;\r\
    \n      :local dbl (\$JParseOut->\"lastConfigChangeTsMs\");\r\
    \n\r\
    \n      if (([:len \$dbl] != 0 && [:len \$lastConfigChangeTsMs] != 0) && (\$dbl != \$lastConfigChangeTsMs || \$jsonError != nil)) do={\r\
    \n        :put \"update response indicates configuration changes or there was a json error\";\r\
    \n        :log info (\"update response indicates configuration changes or there was a json error, running config script\");\r\
    \n        :log info (\"jsonError: \$jsonError\");\r\
    \n        :log info (\"lastConfigChangeTsMs: \$lastConfigChangeTsMs\");\r\
    \n        :log info (\"dbl: \$dbl\");\r\
    \n        :log info (\"JSONIn: \$JSONIn\");\r\
    \n        /system scheduler disable cmdGetDataFromApi;\r\
    \n        /system script run config;\r\
    \n        :error \"there was a json error in the update response\";\r\
    \n\r\
    \n      } else={\r\
    \n        :put \"update response indicates no configuration changes\";\r\
    \n      }\r\
    \n\r\
    \n  # execute commands\r\
    \n\r\
    \n  :local cmds (\$JParseOut->\"cmds\");\r\
    \n  :local numCmds ([:len cmds]);\r\
    \n  :put (\"executing \" . \$numCmds . \" commands\");\r\
    \n\r\
    \n  :foreach cmdKey in=(\$cmds) do={\r\
    \n\r\
    \n    :put \$cmdKey;\r\
    \n\r\
    \n    :local cmd (\$cmdKey->\"cmd\");\r\
    \n    :local stderr (\$cmdKey->\"stderr\");\r\
    \n    :local stdout (\$cmdKey->\"stdout\");\r\
    \n    :local uuidv4 (\$cmdKey->\"uuidv4\");\r\
    \n    :local wsid (\$cmdKey->\"ws_id\");\r\
    \n\r\
    \n    # create a system script with the command contents\r\
    \n    :if ([:len [/system script find name=\"ispappCommand\"]] = 0) do={\r\
    \n      /system script add name=\"ispappCommand\";\r\
    \n    }\r\
    \n    /system script set \"ispappCommand\" source=\"\$cmd\";\r\
    \n\r\
    \n    :log info (\"ispapp is executing command: \" . \$cmd);\r\
    \n\r\
    \n    # run the script and place the output in a known file\r\
    \n    # this runs in the background if not ran with :put\r\
    \n    # resulting in the contents being empty\r\
    \n    :put [:execute script={/system script run ispappCommand;} file=\"ispappCommandOutput.txt\"];\r\
    \n\r\
    \n    :delay 130ms;\r\
    \n\r\
    \n    # send the output file contents to the server as a command response via an update request\r\
    \n    :local output ([/file get [/file find name=\"ispappCommandOutput.txt\"] contents]);\r\
    \n\r\
    \n    # base64 encoded\r\
    \n    :global base64EncodeFunct;\r\
    \n    :local cmdStdoutVal ([\$base64EncodeFunct stringVal=\$output]);\r\
    \n\r\
    \n    # make the request body\r\
    \n    :local cmdJsonData \"{\\\"ws_id\\\":\\\"\$wsid\\\", \\\"uuidv4\\\":\\\"\$uuidv4\\\", \\\"stdout\\\":\\\"\$cmdStdoutVal\\\", \\\"login\\\":\\\"\$login\\\", \\\"key\\\":\\\"\$topKey\\\"}\";\r\
    \n\r\
    \n    #:put \$cmdJsonData;\r\
    \n    #:log info (\"ispapp command response json: \" . \$cmdJsonData);\r\
    \n\r\
    \n    # make the request\r\
    \n    :local cmdResponse ([/tool fetch mode=https http-method=post http-header-field=\"cache-control: no-cache, content-type: application/json\" http-data=\"\$cmdJsonData\" url=\$mergeUpdateCollec\
    torsUrl as-value output=user duration=1500ms]);\r\
    \n\r\
    \n    #:put \$cmdResponse;\r\
    \n\r\
    \n  }\r\
    \n\r\
    \n        # check enable updateFast if set to true\r\
    \n        :local updateFast (\$JParseOut->\"updateFast\");\r\
    \n        #:put (\"updateFast: \" . \$updateFast);\r\
    \n        :if ( \$updateFast = true) do={\r\
    \n          :do {\r\
    \n            :local cmdGetDataSchedulerInterval [/system scheduler get cmdGetDataFromApi interval ];\r\
    \n            :if (\$cmdGetDataSchedulerInterval != \"00:00:02\") do={\r\
    \n              /system scheduler set interval=2s \"cmdGetDataFromApi\";\r\
    \n              /system scheduler set interval=2s \"collectors\";\r\
    \n              /system scheduler set interval=10s \"pingCollector\";\r\
    \n            }\r\
    \n          } on-error={\r\
    \n            :log info (\"CMDGETDATAAPI FUNC CHANGE SCHEDULER  ERROR ========>>>>\");\r\
    \n          }\r\
    \n        } else={\r\
    \n          :do {\r\
    \n\r\
    \n              :global lastUpdateOffsetSec;\r\
    \n              :set lastUpdateOffsetSec (\$JParseOut->\"lastUpdateOffsetSec\");\r\
    \n\r\
    \n              :global lastColUpdateOffsetSec;\r\
    \n              :set lastColUpdateOffsetSec (\$JParseOut->\"lastColUpdateOffsetSec\");\r\
    \n\r\
    \n              :global updateIntervalSeconds;\r\
    \n              :global outageIntervalSeconds;\r\
    \n              :local updateSec (num(\$updateIntervalSeconds-\$lastColUpdateOffsetSec));\r\
    \n              :local outageSec (num(\$outageIntervalSeconds-\$lastColUpdateOffsetSec));\r\
    \n\r\
    \n              if (\$outageSec < 2 || \$outageSec > 300) do={\r\
    \n\r\
    \n                # don't let this change the interval to 0, causing the script to no longer run\r\
    \n                # set sane defaults that will be updated next time a request is successful\r\
    \n\r\
    \n                /system scheduler set interval=10s \"cmdGetDataFromApi\";\r\
    \n                /system scheduler set interval=60s \"collectors\";\r\
    \n                /system scheduler set interval=60s \"pingCollector\";\r\
    \n\r\
    \n             } else={\r\
    \n\r\
    \n                /system scheduler set interval=(\$outageSec) \"cmdGetDataFromApi\";\r\
    \n                /system scheduler set interval=(\$updateSec) \"collectors\";\r\
    \n                /system scheduler set interval=(\$updateSec) \"pingCollector\";\r\
    \n                :log info (\"setting scheduler to seconds: \$outageSec\");\r\
    \n\r\
    \n            }\r\
    \n\r\
    \n          } on-error={\r\
    \n            :log info (\"UPDATE FUNCT CHANGE SCHEDULER  ERROR ========>>>>\");\r\
    \n          }\r\
    \n\r\
    \n        }\r\
    \n\r\
    \n}\r\
    \n}"
add dont-require-permissions=no name=avgCpuCollector owner=admin policy=ftp,reboot,read,write,policy,test,password,sniff,sensitive,romon source="#:log info (\"avgCpuCollector\");\r\
    \n\r\
    \n:global cpuLoad;\r\
    \n\r\
    \n:set cpuLoad ((\$cpuLoad + [/system resource get cpu-load]) / 2);\r\
    \n\r\
    \n#:log info (\"cpuLoad: \$cpuLoad\");\r\
    \n\r\
    \n# run this script again\r\
    \n:delay 4s;\r\
    \n:execute {/system script run avgCpuCollector};"
/system scheduler
add name=initMultipleScript on-event=initMultipleScript policy=\
    ftp,reboot,read,write,policy,test,password,sniff,sensitive,romon \
    start-time=startup
add interval=60s name=pingCollector on-event=pingCollector policy=\
    ftp,reboot,read,write,policy,test,password,sniff,sensitive,romon \
    start-time=startup
add interval=60s name=collectors on-event=collectors policy=\
    ftp,reboot,read,write,policy,test,password,sniff,sensitive,romon \
    start-time=startup
add interval=15s name=cmdGetDataFromApi on-event=cmdGetDataFromApi policy=\
    ftp,reboot,read,write,policy,test,password,sniff,sensitive,romon \
    start-time=startup
add interval=15s name=config on-event=config policy=\
    ftp,reboot,read,write,policy,test,password,sniff,sensitive,romon \
    start-time=startup
/system script run initMultipleScript;
