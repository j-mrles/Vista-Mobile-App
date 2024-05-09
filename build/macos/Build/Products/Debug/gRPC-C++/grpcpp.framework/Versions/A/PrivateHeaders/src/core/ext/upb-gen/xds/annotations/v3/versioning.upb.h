/* This file was generated by upb_generator from the input file:
 *
 *     xds/annotations/v3/versioning.proto
 *
 * Do not edit -- your changes will be discarded when the file is
 * regenerated. */

#ifndef XDS_ANNOTATIONS_V3_VERSIONING_PROTO_UPB_H_
#define XDS_ANNOTATIONS_V3_VERSIONING_PROTO_UPB_H_

#include "upb/generated_code_support.h"

#include "xds/annotations/v3/versioning.upb_minitable.h"

#include "google/protobuf/descriptor.upb_minitable.h"

// Must be last.
#include "upb/port/def.inc"

#ifdef __cplusplus
extern "C" {
#endif

typedef struct xds_annotations_v3_VersioningAnnotation xds_annotations_v3_VersioningAnnotation;
struct google_protobuf_MessageOptions;



/* xds.annotations.v3.VersioningAnnotation */

UPB_INLINE xds_annotations_v3_VersioningAnnotation* xds_annotations_v3_VersioningAnnotation_new(upb_Arena* arena) {
  return (xds_annotations_v3_VersioningAnnotation*)_upb_Message_New(&xds__annotations__v3__VersioningAnnotation_msg_init, arena);
}
UPB_INLINE xds_annotations_v3_VersioningAnnotation* xds_annotations_v3_VersioningAnnotation_parse(const char* buf, size_t size, upb_Arena* arena) {
  xds_annotations_v3_VersioningAnnotation* ret = xds_annotations_v3_VersioningAnnotation_new(arena);
  if (!ret) return NULL;
  if (upb_Decode(buf, size, ret, &xds__annotations__v3__VersioningAnnotation_msg_init, NULL, 0, arena) != kUpb_DecodeStatus_Ok) {
    return NULL;
  }
  return ret;
}
UPB_INLINE xds_annotations_v3_VersioningAnnotation* xds_annotations_v3_VersioningAnnotation_parse_ex(const char* buf, size_t size,
                           const upb_ExtensionRegistry* extreg,
                           int options, upb_Arena* arena) {
  xds_annotations_v3_VersioningAnnotation* ret = xds_annotations_v3_VersioningAnnotation_new(arena);
  if (!ret) return NULL;
  if (upb_Decode(buf, size, ret, &xds__annotations__v3__VersioningAnnotation_msg_init, extreg, options, arena) !=
      kUpb_DecodeStatus_Ok) {
    return NULL;
  }
  return ret;
}
UPB_INLINE char* xds_annotations_v3_VersioningAnnotation_serialize(const xds_annotations_v3_VersioningAnnotation* msg, upb_Arena* arena, size_t* len) {
  char* ptr;
  (void)upb_Encode(msg, &xds__annotations__v3__VersioningAnnotation_msg_init, 0, arena, &ptr, len);
  return ptr;
}
UPB_INLINE char* xds_annotations_v3_VersioningAnnotation_serialize_ex(const xds_annotations_v3_VersioningAnnotation* msg, int options,
                                 upb_Arena* arena, size_t* len) {
  char* ptr;
  (void)upb_Encode(msg, &xds__annotations__v3__VersioningAnnotation_msg_init, options, arena, &ptr, len);
  return ptr;
}
UPB_INLINE void xds_annotations_v3_VersioningAnnotation_clear_previous_message_type(xds_annotations_v3_VersioningAnnotation* msg) {
  const upb_MiniTableField field = {1, 0, 0, kUpb_NoSub, 9, (int)kUpb_FieldMode_Scalar | ((int)kUpb_FieldRep_StringView << kUpb_FieldRep_Shift)};
  _upb_Message_ClearNonExtensionField(msg, &field);
}
UPB_INLINE upb_StringView xds_annotations_v3_VersioningAnnotation_previous_message_type(const xds_annotations_v3_VersioningAnnotation* msg) {
  upb_StringView default_val = upb_StringView_FromString("");
  upb_StringView ret;
  const upb_MiniTableField field = {1, 0, 0, kUpb_NoSub, 9, (int)kUpb_FieldMode_Scalar | ((int)kUpb_FieldRep_StringView << kUpb_FieldRep_Shift)};
  _upb_Message_GetNonExtensionField(msg, &field, &default_val, &ret);
  return ret;
}

UPB_INLINE void xds_annotations_v3_VersioningAnnotation_set_previous_message_type(xds_annotations_v3_VersioningAnnotation *msg, upb_StringView value) {
  const upb_MiniTableField field = {1, 0, 0, kUpb_NoSub, 9, (int)kUpb_FieldMode_Scalar | ((int)kUpb_FieldRep_StringView << kUpb_FieldRep_Shift)};
  _upb_Message_SetNonExtensionField(msg, &field, &value);
}

UPB_INLINE bool xds_annotations_v3_has_versioning(const struct google_protobuf_MessageOptions* msg) {
  return _upb_Message_HasExtensionField(msg, &xds_annotations_v3_versioning_ext);
}
UPB_INLINE void xds_annotations_v3_clear_versioning(struct google_protobuf_MessageOptions* msg) {
  _upb_Message_ClearExtensionField(msg, &xds_annotations_v3_versioning_ext);
}
UPB_INLINE const xds_annotations_v3_VersioningAnnotation* xds_annotations_v3_versioning(const struct google_protobuf_MessageOptions* msg) {
  const upb_MiniTableExtension* ext = &xds_annotations_v3_versioning_ext;
  UPB_ASSUME(!upb_IsRepeatedOrMap(&ext->field));
  UPB_ASSUME(_upb_MiniTableField_GetRep(&ext->field) == kUpb_FieldRep_8Byte);
  const xds_annotations_v3_VersioningAnnotation* default_val = NULL;
  const xds_annotations_v3_VersioningAnnotation* ret;
  _upb_Message_GetExtensionField(msg, ext, &default_val, &ret);
  return ret;
}
UPB_INLINE void xds_annotations_v3_set_versioning(struct google_protobuf_MessageOptions* msg, const xds_annotations_v3_VersioningAnnotation* val, upb_Arena* arena) {
  const upb_MiniTableExtension* ext = &xds_annotations_v3_versioning_ext;
  UPB_ASSUME(!upb_IsRepeatedOrMap(&ext->field));
  UPB_ASSUME(_upb_MiniTableField_GetRep(&ext->field) == kUpb_FieldRep_8Byte);
  bool ok = _upb_Message_SetExtensionField(msg, ext, &val, arena);
  UPB_ASSERT(ok);
}
#ifdef __cplusplus
}  /* extern "C" */
#endif

#include "upb/port/undef.inc"

#endif  /* XDS_ANNOTATIONS_V3_VERSIONING_PROTO_UPB_H_ */
