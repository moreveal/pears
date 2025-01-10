stock bool:SerializeDynamicObjectProperties(objectid, &JsonNode:node)
{
    if (!IsValidDynamicObject(objectid))
    {
        return false;
    }

    new modelid;
    new Float:posX, Float:posY, Float:posZ;
    new Float:rotX, Float:rotY, Float:rotZ;
    new JsonNode:materials = JSON_INVALID_NODE;
    new JsonNode:materialTexts = JSON_INVALID_NODE;

    modelid = Streamer_GetIntData(STREAMER_TYPE_OBJECT, objectid, E_STREAMER_MODEL_ID);
    GetDynamicObjectPos(objectid, posX, posY, posZ);
    GetDynamicObjectRot(objectid, rotX, rotY, rotZ);
    materials = JSON_Array();
    for (new slot = 0; slot < 16; slot++)
    {
        if (!IsDynamicObjectMaterialUsed(objectid, slot)) continue;

        new modelId;
        new textureLibrary[256];
        new textureName[256];
        new materialColour;
        GetDynamicObjectMaterial(objectid, slot, modelId, textureLibrary, textureName, materialColour);

        JSON_ArrayAppendEx(materials, JSON_Object(
            "slot", JSON_Int(slot),
            "modelId", JSON_Int(modelId),
            "textureLibrary", JSON_String(textureLibrary),
            "textureName", JSON_String(textureName),
            "materialColour", JSON_Int(materialColour)
        ));
    }
    materialTexts = JSON_Array();
    for (new slot = 0; slot < 16; slot++)
    {
        if (!IsDynamicObjectMaterialTextUsed(objectid, slot)) continue;

        new text[512];
        new materialSize;
        new fontFace[32];
        new fontSize;
        new isBold;
        new fontColour;
        new backColour;
        new textAlignment;
        GetDynamicObjectMaterialText(objectid, slot, text, materialSize, fontFace, fontSize, isBold, fontColour, backColour, textAlignment);

        JSON_ArrayAppendEx(materials, JSON_Object(
            "slot", JSON_Int(slot),
            "text", JSON_String(text),
            "materialSize", JSON_Int(materialSize),
            "fontFace", JSON_String(fontFace),
            "fontSize", JSON_Int(fontSize),
            "isBold", JSON_Bool(bool:isBold),
            "fontColour", JSON_Int(fontColour),
            "backColour", JSON_Int(backColour),
            "textAlignment", JSON_Int(textAlignment)
        ));
    }
    
    JSON_Cleanup(node);
    node = JSON_Object(
        "model", JSON_Int(modelid),
        "position", JSON_Object(
            "x", JSON_Float(posX),
            "y", JSON_Float(posY),
            "z", JSON_Float(posZ)
        ),
        "rotation", JSON_Object(
            "x", JSON_Float(rotX),
            "y", JSON_Float(rotY),
            "z", JSON_Float(rotZ)
        ),
        "materials", materials,
        "materialTexts", materialTexts
    );

    return true;
}

#pragma warning disable 240

stock JsonCallResult:DeserializeDynamicObjectProperties(&JsonNode:node, &STREAMER_TAG_OBJECT:object)
{
    #define JSON_DESERIALIZE_ERR_CHECKUP_RET(%0)    \
    {                                           \
        new JsonCallResult:callResult = %0;     \
        if (callResult != JSON_CALL_NO_ERR)     \
        {                                       \
            DestroyDynamicObject(object);       \
            return callResult;                  \
        }                                       \
    }

    object = INVALID_STREAMER_ID;

    new modelid;
    new Float:posX, Float:posY, Float:posZ;
    new Float:rotX, Float:rotY, Float:rotZ;

    JSON_GetInt(node, "model", modelid);

    {
        new JsonNode:positionNode = JSON_INVALID_NODE;
        JSON_GetObject(node, "position", positionNode);
        JSON_GetFloat(positionNode, "x", posX);
        JSON_GetFloat(positionNode, "y", posY);
        JSON_GetFloat(positionNode, "z", posZ);
    }

    {
        new JsonNode:rotationNode = JSON_INVALID_NODE;
        JSON_GetObject(node, "rotation", rotationNode);
        JSON_GetFloat(rotationNode, "x", rotX);
        JSON_GetFloat(rotationNode, "y", rotY);
        JSON_GetFloat(rotationNode, "z", rotZ);
    }

    object = CreateDynamicObject(modelid, posX, posY, posZ, rotX, rotY, rotZ);
    if (!IsValidDynamicObject(object))
    {
        return JSON_CALL_UNKNOWN_ERR;
    }

    {
        new JsonNode:materialsNode = JSON_INVALID_NODE;
        JSON_GetArray(node, "materials", materialsNode);
        new JsonNode:material = JSON_INVALID_NODE;
        new index = -1;
        while(!JSON_ArrayIterate(materialsNode, index, material))
        {
            new slot;
            new modelId;
            new textureLibrary[256];
            new textureName[256];
            new materialColour;

            JSON_GetInt(material, "slot", slot);
            JSON_GetInt(material, "modelId", modelId);
            JSON_GetString(material, "textureLibrary", textureLibrary);
            JSON_GetString(material, "textureName", textureName);
            JSON_GetInt(material, "materialColour", materialColour);

            SetDynamicObjectMaterial(object, slot, modelId, textureLibrary, textureName, materialColour);
        }
    }

    {
        new JsonNode:materialTextsNode = JSON_INVALID_NODE;
        JSON_GetArray(node, "materialTexts", materialTextsNode);
        new JsonNode:materialText = JSON_INVALID_NODE;
        new index = -1;
        while(!JSON_ArrayIterate(materialTextsNode, index, materialText))
        {
            new slot;
            new text[512];
            new materialSize;
            new fontFace[32];
            new fontSize;
            new bool:isBold;
            new fontColour;
            new backColour;
            new textAlignment;

            JSON_GetInt(materialText, "slot", slot);
            JSON_GetString(materialText, "text", text);
            JSON_GetInt(materialText, "materialSize", materialSize);
            JSON_GetString(materialText, "fontFace", fontFace);
            JSON_GetInt(materialText, "fontSize", fontSize);
            JSON_GetBool(materialText, "isBold", isBold);
            JSON_GetInt(materialText, "fontColour", fontColour);
            JSON_GetInt(materialText, "backColour", backColour);
            JSON_GetInt(materialText, "textAlignment", textAlignment);

            SetDynamicObjectMaterialText(object, slot, text, materialSize, fontFace, fontSize, _:isBold, fontColour, backColour, textAlignment);
        }
    }

    return JSON_CALL_NO_ERR;
    #undef JSON_DESERIALIZE_ERR_CHECKUP_RET
}
#pragma warning enable 240

stock bool:SerializeDynamicObjectPropertiesToJsonStr(objectid, out[], const outSize = sizeof(out))
{
    new JsonNode:node = JSON_INVALID_NODE;
    if (!SerializeDynamicObjectProperties(objectid, node))
    {
        return false;
    }
    if (JSON_Stringify(node, out, outSize) != JSON_CALL_NO_ERR)
    {
        return false;
    }
    return true;
}

stock JsonCallResult:DeserializeDynamicObjectPropertiesFromJsonStr(const json[], &STREAMER_TAG_OBJECT:object)
{
    new JsonNode:node = JSON_INVALID_NODE;
    new JsonCallResult:result = JSON_Parse(json, node);
    if (result != JSON_CALL_NO_ERR)
    {
        return result;
    }
    result = DeserializeDynamicObjectProperties(node, object);
    return result;
}

