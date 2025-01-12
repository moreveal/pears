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
            "texLib", JSON_String(textureLibrary),
            "tex", JSON_String(textureName),
            "matCol", JSON_Int(materialColour)
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
            "matSz", JSON_Int(materialSize),
            "fontFace", JSON_String(fontFace),
            "fontSz", JSON_Int(fontSize),
            "isBold", JSON_Bool(bool:isBold),
            "fontCol", JSON_Int(fontColour),
            "backCol", JSON_Int(backColour),
            "textAlign", JSON_Int(textAlignment)
        ));
    }
    
    JSON_Cleanup(node);
    node = JSON_Object(
        "model", JSON_Int(modelid),
        "pos", JSON_Object(
            "x", JSON_Float(posX),
            "y", JSON_Float(posY),
            "z", JSON_Float(posZ)
        ),
        "rot", JSON_Object(
            "x", JSON_Float(rotX),
            "y", JSON_Float(rotY),
            "z", JSON_Float(rotZ)
        ),
        "mats", materials,
        "matTexts", materialTexts
    );

    return true;
}

stock JsonCallResult:DeserializeDynamicObjectProperties(&JsonNode:node, &STREAMER_TAG_OBJECT:object)
{
    object = INVALID_STREAMER_ID;

    new modelid;
    new Float:posX, Float:posY, Float:posZ;
    new Float:rotX, Float:rotY, Float:rotZ;

    JSON_GetInt(node, "model", modelid);

    {
        new JsonNode:positionNode = JSON_INVALID_NODE;
#if 0
        JSON_GetObject(node, "pos", positionNode);
#else
        if (JSON_GetObject(node, "pos", positionNode) != JSON_CALL_NO_ERR)
        {
            JSON_GetObject(node, "position", positionNode);
        }
#endif
        JSON_GetFloat(positionNode, "x", posX);
        JSON_GetFloat(positionNode, "y", posY);
        JSON_GetFloat(positionNode, "z", posZ);
    }

    {
        new JsonNode:rotationNode = JSON_INVALID_NODE;
#if 0
        JSON_GetObject(node, "rot", rotationNode);
#else
        if (JSON_GetObject(node, "rot", rotationNode) != JSON_CALL_NO_ERR)
        {
            JSON_GetObject(node, "rotation", rotationNode);
        }
#endif
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
#if 0
        JSON_GetArray(node, "mats", materialsNode);
#else
        if (JSON_GetArray(node, "mats", materialsNode) != JSON_CALL_NO_ERR)
        {
            JSON_GetArray(node, "materials", materialsNode);
        }
#endif
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
#if 0
            JSON_GetString(material, "texLib", textureLibrary);
#else
            if (JSON_GetString(material, "texLib", textureLibrary) != JSON_CALL_NO_ERR)
            {
                JSON_GetString(material, "textureLibrary", textureLibrary);
            }
#endif
#if 0
            JSON_GetString(material, "tex", textureName);
#else
            if (JSON_GetString(material, "tex", textureName) != JSON_CALL_NO_ERR)
            {
                JSON_GetString(material, "textureName", textureName);
            }
#endif
#if 0
            JSON_GetInt(material, "matCol", materialColour);
#else
            if (JSON_GetInt(material, "matCol", materialColour) != JSON_CALL_NO_ERR)
            {
                JSON_GetInt(material, "materialColour", materialColour);
            }
#endif

            SetDynamicObjectMaterial(object, slot, modelId, textureLibrary, textureName, materialColour);
        }
    }

    {
        new JsonNode:materialTextsNode = JSON_INVALID_NODE;
#if 0
        JSON_GetArray(node, "matTexts", materialTextsNode);
#else
        if (JSON_GetArray(node, "matTexts", materialTextsNode) != JSON_CALL_NO_ERR)
        {
            JSON_GetArray(node, "materialTexts", materialTextsNode);
        }
#endif
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
#if 0
            JSON_GetInt(materialText, "matSz", materialSize);
#else
            if (JSON_GetInt(materialText, "matSz", materialSize) != JSON_CALL_NO_ERR)
            {
                JSON_GetInt(materialText, "materialSize", materialSize);
            }
#endif
            JSON_GetString(materialText, "fontFace", fontFace);
#if 0
            JSON_GetInt(materialText, "fontSz", fontSize);
#else
            if (JSON_GetInt(materialText, "fontSz", fontSize) != JSON_CALL_NO_ERR)
            {
                JSON_GetInt(materialText, "fontSize", fontSize);
            }
#endif
            JSON_GetBool(materialText, "isBold", isBold);
#if 0
            JSON_GetInt(materialText, "fontCol", fontColour);
#else
            if (JSON_GetInt(materialText, "fontCol", fontColour) != JSON_CALL_NO_ERR)
            {
                JSON_GetInt(materialText, "fontColour", fontColour);
            }
#endif
#if 0
            JSON_GetInt(materialText, "backCol", backColour);
#else
            if (JSON_GetInt(materialText, "backCol", backColour) != JSON_CALL_NO_ERR)
            {
                JSON_GetInt(materialText, "backColour", backColour);
            }
#endif
#if 0
            JSON_GetInt(materialText, "textAlign", textAlignment);
#else
            if (JSON_GetInt(materialText, "textAlign", textAlignment) != JSON_CALL_NO_ERR)
            {
                JSON_GetInt(materialText, "textAlignment", textAlignment);
            }
#endif

            SetDynamicObjectMaterialText(object, slot, text, materialSize, fontFace, fontSize, _:isBold, fontColour, backColour, textAlignment);
        }
    }

    return JSON_CALL_NO_ERR;
}

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

