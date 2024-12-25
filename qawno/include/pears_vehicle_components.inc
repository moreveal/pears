#if defined _INC_vehicle_components_plugin
	#endinput
#endif
#define _INC_vehicle_components_plugin

#pragma tabsize 4

enum VEHICLE_COMPONENTS_TYPE
{
    VEHICLE_COMPONENT_NONE = -1,
    VEHICLE_COMPONENT_SPOILER = 0,
    VEHICLE_COMPONENT_HOOD = 1,
    VEHICLE_COMPONENT_ROOF = 2,
    VEHICLE_COMPONENT_SIDESKIRT = 3,
    VEHICLE_COMPONENT_LAMPS = 4,
    VEHICLE_COMPONENT_NITRO = 5,
    VEHICLE_COMPONENT_EXHAUST = 6,
    VEHICLE_COMPONENT_WHEELS = 7,
    VEHICLE_COMPONENT_STEREO = 8,
    VEHICLE_COMPONENT_HYDRAULICS = 9,
    VEHICLE_COMPONENT_FRONTBUMPER = 10,
    VEHICLE_COMPONENT_REARBUMPER = 11,
    VEHICLE_COMPONENT_VENTRIGHT = 12,
    VEHICLE_COMPONENT_VENTLEFT = 13,
    VEHICLE_COMPONENT_FRONTBULLBAR = 14,
    VEHICLE_COMPONENT_REARBULLBAR = 15
};
 
/*
                                                                           
    888b      88                       88                                      
    8888b     88                ,d     ""                                      
    88 `8b    88                88                                             
    88  `8b   88  ,adPPYYba,  MM88MMM  88  8b       d8   ,adPPYba,  ,adPPYba,  
    88   `8b  88  ""     `Y8    88     88  `8b     d8'  a8P_____88  I8[    ""  
    88    `8b 88  ,adPPPPP88    88     88   `8b   d8'   8PP"""""""   `"Y8ba,   
    88     `8888  88,    ,88    88,    88    `8b,d8'    "8b,   ,aa  aa    ]8I  
    88      `888  `"8bbdP"Y8    "Y888  88      "8"       `"Ybbd8"'  `"YbbdP"'  
                                                                           
                                                                                
*/

native bool:AddVehicleCustomComponent(vehicleid, component);
native bool:RemoveVehicleCustomComponent(vehicleid, component);
native GetVehicleCustomComponentInSlot(vehicleid, slot);

native GetVehicleCustomComponentType(component);
native SetVehicleCustomComponentType(component, slot);
native bool:IsVehicleCustomComponent(component);

/*
    88        88                            88                    
    88        88                            88                    
    88        88                            88                    
    88aaaaaaaa88   ,adPPYba,    ,adPPYba,   88   ,d8   ,adPPYba,  
    88""""""""88  a8"     "8a  a8"     "8a  88 ,a8"    I8[    ""  
    88        88  8b       d8  8b       d8  8888[       `"Y8ba,   
    88        88  "8a,   ,a8"  "8a,   ,a8"  88`"Yba,   aa    ]8I  
    88        88   `"YbbdP"'    `"YbbdP"'   88   `Y8a  `"YbbdP"'  
*/

stock _PVEHICLE_RemoveVehicleComponent(vehicleid, component)
{
	RemoveVehicleCustomComponent(vehicleid, component);
    return RemoveVehicleComponent(vehicleid, component);
}

#if defined _ALS_RemoveVehicleComponent
    #undef RemoveVehicleComponent
#else
    #define _ALS_RemoveVehicleComponent
#endif
#define RemoveVehicleComponent _PVEHICLE_RemoveVehicleComponent
