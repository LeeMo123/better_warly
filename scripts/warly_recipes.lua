-- 骨粉
AddRecipe2("spice_bone",
    { Ingredient("boneshard", 3) },
    TECH.FOODPROCESSING_ONE,
    {
        builder_tag = "professionalchef", numtogive = 2, nounlock = true ,
        atlas= "images/inventoryimages/spice_bone.xml",
    }
)

-- 格罗姆粉
AddRecipe2("spice_glom",
    { Ingredient("glommerfuel", 3) },
    TECH.FOODPROCESSING_ONE,
    {
        builder_tag = "professionalchef", numtogive = 2, nounlock = true ,
        atlas= "images/inventoryimages/spice_glom.xml",
    }
)

-- 壳粉
AddRecipe2("spice_shell",
    { Ingredient("cookiecuttershell", 3) },
    TECH.FOODPROCESSING_ONE,
    {
        builder_tag = "professionalchef", numtogive = 2, nounlock = true ,
        atlas= "images/inventoryimages/spice_shell.xml",
    }
)

-- 黄油
AddRecipe2(
    "butter",
    {
        Ingredient("goatmilk", 2),
    },
    TECH.NONE,
    {
        sg_state="dolongaction",
        no_deconstruction = true,
        builder_tag = "masterchef",
        image = "butter.tex",
        description = "wanderingtradershop_butter",
        numtogive = 1,
    },
    {"CHARACTER"}
)

-- 种子包
AddRecipe2(
    "wanderingtradershop_warly_seedpacket",
    {
        Ingredient("ash", 3),
    },
    TECH.LOST,
    {
        limitedamount = true, 
        nounlock = true, 
        actionstr="WANDERINGTRADERSHOP", 
        sg_state="give",
        product = "warly_seedpacket",
        no_deconstruction = true,
        -- builder_tag = "masterchef",
        image = "yotc_seedpacket.tex",
        description = "yotc_seedpacket",
        numtogive = 1,
    }
)

-- 修补肉块
AddRecipe2(
    "remeat",
    {
        Ingredient("saltrock", 2),
        Ingredient("meat", 1)
    },
    TECH.SCIENCE_TWO,
    {        
        atlas= "images/inventoryimages/remeat.xml",
    },
    {"WEAPONS", "REFINE"}
)