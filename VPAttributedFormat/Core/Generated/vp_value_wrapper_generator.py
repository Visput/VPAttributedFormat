__author__ = 'Uladzimir Papko'

import re

types = ["VPTypeId",
        "VPTypeVoidPointer",
        "VPTypeChar",
        "VPTypeCharPointer",
        "VPTypeSignedCharPointer",
        "VPTypeUnsignedChar",
        "VPTypeUnichar",
        "VPTypeUnicharPointer",
        "VPTypeShort",
        "VPTypeShortPointer",
        "VPTypeUnsignedShort",
        "VPTypeInt",
        "VPTypeIntPointer",
        "VPTypeUnsignedInt",
        "VPTypeWint_t",
        "VPTypeIntmax_t",
        "VPTypeIntmax_tPointer",
        "VPTypeUintmax_t",
        "VPTypeSize_t",
        "VPTypeSize_tPointer",
        "VPTypePtrdiff_t",
        "VPTypePtrdiff_tPointer",
        "VPTypeLong",
        "VPTypeLongPointer",
        "VPTypeUnsignedLong",
        "VPTypeLongLong",
        "VPTypeLongLongPointer",
        "VPTypeUnsignedLongLong",
        "VPTypeDouble",
        "VPTypeLongDouble"]

# Create .h and .m files
file_name = "VPValueWrapper"
header_file = open(file_name + ".h", 'w')
impl_file = open(file_name + ".m", 'w')

comment = "//\n// This file was generated by python script vp_value_wrapper_generator.py\n// Don't edit it manually\n//\n\n"
header_file.write(comment)
header_file.write("#import <Foundation/Foundation.h>\n\n")

impl_file.write(comment)
impl_file.write("#import \"" + file_name + ".h\"\n\n")

for type in types:
    class_name = type.replace("Type", "") + "ValueWrapper"

    type_parts = re.findall('[A-Z][^A-Z]*', type.replace("VPType", ""))

    # Build language type. For example: "VPTypeLongLongPointer" -> "long long *"
    lang_type = ""
    for i in range(0, len(type_parts)):
        type_part = type_parts[i]

        if type_part == "Pointer":
            lang_type += "*"
        else:
            lang_type += type_part.lower()

        if i != len(type_parts) - 1:
            lang_type += " "

    # Fill .h file
    header_file.write("@interface " + class_name + " : NSObject\n\n" +
                      "@property (nonatomic, readonly, assign) " + lang_type + " value;\n\n" +
                      "- (instancetype)initWithValue:(" + lang_type + ")value;\n\n" +
                      "@end\n\n\n")

    # Fill .m file
    impl_file.write("@interface " + class_name + " ()\n\n" +
                    "@property (nonatomic, assign) " + lang_type + " value;\n\n" +
                    "@end\n\n" +
                    "@implementation " + class_name + "\n\n" +
                    "- (instancetype)initWithValue:(" + lang_type + ")value {\n" +
                    "    self = [super init];\n" +
                    "    if (self) {\n" +
                    "        self.value = value;\n" +
                    "    }\n" +
                    "    return self;\n" +
                    "}\n\n" +
                    "@end\n\n\n")


# Close .h and .m files
header_file.close()
impl_file.close()