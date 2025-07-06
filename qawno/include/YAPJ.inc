// MIT License

// Copyright (c) 2022 Northn

// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:

// The above copyright notice and this permission notice shall be included in all
// copies or substantial portions of the Software.

// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// SOFTWARE.


#if !defined JSON_INC_
  #define JSON_INC_

  #if !defined PACK_PLUGIN_VERSION
    #define PACK_PLUGIN_VERSION(%0,%1,%2) (((%0) << 16) | ((%1) << 8) | (%2))
  #endif

  #define JSON_VERSION PACK_PLUGIN_VERSION(1, 2, 6)

  enum JsonNodeType {
    JSON_NODE_NULL = 64,
    JSON_NODE_BOOLEAN,
    JSON_NODE_INT,
    JSON_NODE_NUMBER = JSON_NODE_INT,
    JSON_NODE_FLOAT,
    JSON_NODE_STRING,
    JSON_NODE_OBJECT,
    JSON_NODE_ARRAY,

    JSON_NODE_MAX
  };

  enum JsonCallResult {
    JSON_CALL_NO_ERR,
    JSON_CALL_UNKNOWN_ERR,
    JSON_CALL_NODE_NOT_EXISTS_ERR,
    JSON_CALL_PARSER_ERR,
    JSON_CALL_NO_SUCH_FILE_ERR,
    JSON_CALL_NO_SUCH_DIR_ERR,
    JSON_CALL_WRONG_TYPE_ERR,
    JSON_CALL_NO_RETURN_STRING_ERR,
    JSON_CALL_WATCHER_EXISTS_ERR,
    JSON_CALL_NO_SUCH_WATCHER_ERR,

    JSON_CALL_MAX_ERR
  };

  enum JsonWatcherFileState {
    JSON_WATCHER_FILE_CREATED,
    JSON_WATCHER_FILE_MODIFIED,
    JSON_WATCHER_FILE_ERASED,

    JSON_WATCHER_FILE_MAX
  };

  #if !defined __cplusplus
    #define JSON_INVALID_NODE JsonNode:0

    native JsonCallResult:JSON_Parse(const buf[], &JsonNode:node);
    native JsonCallResult:JSON_ParseFile(const path[], &JsonNode:node);
    native JsonCallResult:JSON_SaveFile(const path[], const JsonNode:node, indent = -1);
    native JsonCallResult:JSON_Stringify(const JsonNode:node, buf[], len = sizeof(buf), indent = -1);
    native JsonCallResult:JSON_Dump(const JsonNode:node, indent = -1);
    native JsonNodeType:JSON_NodeType(const JsonNode:node);

    native JsonNode:JSON_Null();
    native JsonNode:JSON_Bool(const bool:value);
    native JsonNode:JSON_Int(const value);
    native JsonNode:JSON_Float(const Float:value);
    native JsonNode:JSON_String(const value[]);
    native JsonNode:JSON_Object({_, JsonNode}:...);
    native JsonNode:JSON_Array(JsonNode:...);

    native JsonNode:JSON_Append(const JsonNode:first_node, const JsonNode:second_node);
    native JsonNode:operator+(JsonNode:first_node, JsonNode:second_node) = JSON_Append;

    native JsonCallResult:JSON_SetNull(JsonNode:node, const key[]);
    native JsonCallResult:JSON_SetBool(JsonNode:node, const key[], const bool:value);
    native JsonCallResult:JSON_SetInt(JsonNode:node, const key[], const value);
    native JsonCallResult:JSON_SetFloat(JsonNode:node, const key[], const Float:value);
    native JsonCallResult:JSON_SetString(JsonNode:node, const key[], const value[]);
    native JsonCallResult:JSON_SetObject(JsonNode:node, const key[], const JsonNode:value);
    native JsonCallResult:JSON_SetArray(JsonNode:node, const key[], const JsonNode:value);

    native JsonCallResult:JSON_GetBool(const JsonNode:node, const key[], &bool:output);
    native JsonCallResult:JSON_GetInt(const JsonNode:node, const key[], &output);
    native JsonCallResult:JSON_GetFloat(const JsonNode:node, const key[], &Float:output);
    native JsonCallResult:JSON_GetString(const JsonNode:node, const key[], output[], len = sizeof(output));
    native JsonCallResult:JSON_GetObject(const JsonNode:node, const key[], &JsonNode:output);
    native JsonCallResult:JSON_GetArray(const JsonNode:node, const key[], &JsonNode:output);

    native JsonNodeType:JSON_GetType(const JsonNode:node, const key[]);

    native JsonCallResult:JSON_ArrayLength(const JsonNode:node, &length);
    native JsonCallResult:JSON_ArrayObject(const JsonNode:node, index, &JsonNode:output);
    native JsonCallResult:JSON_ArrayIterate(const JsonNode:node, &index, &JsonNode:output);
    native JsonCallResult:JSON_ArrayAppend(JsonNode:node, const key[], const JsonNode:input);
    native JsonCallResult:JSON_ArrayRemove(JsonNode:node, const key[], const JsonNode:input);
    native JsonCallResult:JSON_ArrayRemoveIndex(JsonNode:node, const key[], const index);
    native JsonCallResult:JSON_ArrayClear(JsonNode:node, const key[]);
    //native JsonCallResult:JSON_ArrayKeys(JsonNode:node, const key[]);
    native JsonCallResult:JSON_Remove(JsonNode:node, const key[]);

    native JsonCallResult:JSON_ArrayAppendEx(JsonNode:node, const JsonNode:input);

    native JsonCallResult:JSON_GetNodeBool(const JsonNode:node, &bool:output);
    native JsonCallResult:JSON_GetNodeInt(const JsonNode:node, &output);
    native JsonCallResult:JSON_GetNodeFloat(const JsonNode:node, &Float:output);
    native JsonCallResult:JSON_GetNodeString(const JsonNode:node, output[], len = sizeof(output));

    native JsonCallResult:JSON_StartWatcher(const filename[]);
    native JsonCallResult:JSON_StopWatcher(const filename[]);
    forward OnJSONFileModified(const filename[], const JsonWatcherFileState:filestate);

    native JsonCallResult:JSON_Cleanup(JsonNode:node);

    stock operator~(const JsonNode:nodes[], len) {
      for(new i; i < len; ++i) {
        JSON_Cleanup(nodes[i]);
      }
    }
  #else
    #define JSON_INVALID_NODE 0
  #endif // !defined __cplusplus
#endif // JSON_INC_
