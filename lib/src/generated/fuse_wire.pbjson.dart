// This is a generated file - do not edit.
//
// Generated from fuse_wire.proto.

// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names
// ignore_for_file: curly_braces_in_flow_control_structures
// ignore_for_file: deprecated_member_use_from_same_package, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_relative_imports
// ignore_for_file: unused_import

import 'dart:convert' as $convert;
import 'dart:core' as $core;
import 'dart:typed_data' as $typed_data;

@$core.Deprecated('Use fuseMessageDescriptor instead')
const FuseMessage$json = {
  '1': 'FuseMessage',
  '2': [
    {'1': 'id', '3': 1, '4': 1, '5': 4, '10': 'id'},
    {'1': 'fh', '3': 2, '4': 1, '5': 4, '10': 'fh'},
    {
      '1': 'request',
      '3': 3,
      '4': 1,
      '5': 11,
      '6': '.bentos.fuse.FuseRequest',
      '9': 0,
      '10': 'request'
    },
    {
      '1': 'response',
      '3': 4,
      '4': 1,
      '5': 11,
      '6': '.bentos.fuse.FuseResponse',
      '9': 0,
      '10': 'response'
    },
  ],
  '8': [
    {'1': 'payload'},
  ],
};

/// Descriptor for `FuseMessage`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List fuseMessageDescriptor = $convert.base64Decode(
    'CgtGdXNlTWVzc2FnZRIOCgJpZBgBIAEoBFICaWQSDgoCZmgYAiABKARSAmZoEjQKB3JlcXVlc3'
    'QYAyABKAsyGC5iZW50b3MuZnVzZS5GdXNlUmVxdWVzdEgAUgdyZXF1ZXN0EjcKCHJlc3BvbnNl'
    'GAQgASgLMhkuYmVudG9zLmZ1c2UuRnVzZVJlc3BvbnNlSABSCHJlc3BvbnNlQgkKB3BheWxvYW'
    'Q=');

@$core.Deprecated('Use fuseRequestDescriptor instead')
const FuseRequest$json = {
  '1': 'FuseRequest',
  '2': [
    {
      '1': 'open',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.bentos.fuse.OpenReq',
      '9': 0,
      '10': 'open'
    },
    {
      '1': 'read',
      '3': 2,
      '4': 1,
      '5': 11,
      '6': '.bentos.fuse.ReadReq',
      '9': 0,
      '10': 'read'
    },
    {
      '1': 'write',
      '3': 3,
      '4': 1,
      '5': 11,
      '6': '.bentos.fuse.WriteReq',
      '9': 0,
      '10': 'write'
    },
    {
      '1': 'flush',
      '3': 4,
      '4': 1,
      '5': 11,
      '6': '.bentos.fuse.FlushReq',
      '9': 0,
      '10': 'flush'
    },
    {
      '1': 'release',
      '3': 5,
      '4': 1,
      '5': 11,
      '6': '.bentos.fuse.ReleaseReq',
      '9': 0,
      '10': 'release'
    },
    {
      '1': 'fsync',
      '3': 6,
      '4': 1,
      '5': 11,
      '6': '.bentos.fuse.FsyncReq',
      '9': 0,
      '10': 'fsync'
    },
    {
      '1': 'ioctl',
      '3': 7,
      '4': 1,
      '5': 11,
      '6': '.bentos.fuse.IoctlReq',
      '9': 0,
      '10': 'ioctl'
    },
    {
      '1': 'poll',
      '3': 8,
      '4': 1,
      '5': 11,
      '6': '.bentos.fuse.PollReq',
      '9': 0,
      '10': 'poll'
    },
    {
      '1': 'lookup',
      '3': 16,
      '4': 1,
      '5': 11,
      '6': '.bentos.fuse.LookupReq',
      '9': 0,
      '10': 'lookup'
    },
    {
      '1': 'forget',
      '3': 17,
      '4': 1,
      '5': 11,
      '6': '.bentos.fuse.ForgetReq',
      '9': 0,
      '10': 'forget'
    },
    {
      '1': 'getattr',
      '3': 18,
      '4': 1,
      '5': 11,
      '6': '.bentos.fuse.GetattrReq',
      '9': 0,
      '10': 'getattr'
    },
    {
      '1': 'setattr',
      '3': 19,
      '4': 1,
      '5': 11,
      '6': '.bentos.fuse.SetattrReq',
      '9': 0,
      '10': 'setattr'
    },
    {
      '1': 'readlink',
      '3': 20,
      '4': 1,
      '5': 11,
      '6': '.bentos.fuse.ReadlinkReq',
      '9': 0,
      '10': 'readlink'
    },
    {
      '1': 'mknod',
      '3': 21,
      '4': 1,
      '5': 11,
      '6': '.bentos.fuse.MknodReq',
      '9': 0,
      '10': 'mknod'
    },
    {
      '1': 'mkdir',
      '3': 22,
      '4': 1,
      '5': 11,
      '6': '.bentos.fuse.MkdirReq',
      '9': 0,
      '10': 'mkdir'
    },
    {
      '1': 'unlink',
      '3': 23,
      '4': 1,
      '5': 11,
      '6': '.bentos.fuse.UnlinkReq',
      '9': 0,
      '10': 'unlink'
    },
    {
      '1': 'rmdir',
      '3': 24,
      '4': 1,
      '5': 11,
      '6': '.bentos.fuse.RmdirReq',
      '9': 0,
      '10': 'rmdir'
    },
    {
      '1': 'symlink',
      '3': 25,
      '4': 1,
      '5': 11,
      '6': '.bentos.fuse.SymlinkReq',
      '9': 0,
      '10': 'symlink'
    },
    {
      '1': 'rename',
      '3': 26,
      '4': 1,
      '5': 11,
      '6': '.bentos.fuse.RenameReq',
      '9': 0,
      '10': 'rename'
    },
    {
      '1': 'link',
      '3': 27,
      '4': 1,
      '5': 11,
      '6': '.bentos.fuse.LinkReq',
      '9': 0,
      '10': 'link'
    },
    {
      '1': 'opendir',
      '3': 28,
      '4': 1,
      '5': 11,
      '6': '.bentos.fuse.OpendirReq',
      '9': 0,
      '10': 'opendir'
    },
    {
      '1': 'readdir',
      '3': 29,
      '4': 1,
      '5': 11,
      '6': '.bentos.fuse.ReaddirReq',
      '9': 0,
      '10': 'readdir'
    },
    {
      '1': 'releasedir',
      '3': 30,
      '4': 1,
      '5': 11,
      '6': '.bentos.fuse.ReleasedirReq',
      '9': 0,
      '10': 'releasedir'
    },
    {
      '1': 'fsyncdir',
      '3': 31,
      '4': 1,
      '5': 11,
      '6': '.bentos.fuse.FsyncdirReq',
      '9': 0,
      '10': 'fsyncdir'
    },
    {
      '1': 'statfs',
      '3': 32,
      '4': 1,
      '5': 11,
      '6': '.bentos.fuse.StatfsReq',
      '9': 0,
      '10': 'statfs'
    },
    {
      '1': 'setxattr',
      '3': 33,
      '4': 1,
      '5': 11,
      '6': '.bentos.fuse.SetxattrReq',
      '9': 0,
      '10': 'setxattr'
    },
    {
      '1': 'getxattr',
      '3': 34,
      '4': 1,
      '5': 11,
      '6': '.bentos.fuse.GetxattrReq',
      '9': 0,
      '10': 'getxattr'
    },
    {
      '1': 'listxattr',
      '3': 35,
      '4': 1,
      '5': 11,
      '6': '.bentos.fuse.ListxattrReq',
      '9': 0,
      '10': 'listxattr'
    },
    {
      '1': 'removexattr',
      '3': 36,
      '4': 1,
      '5': 11,
      '6': '.bentos.fuse.RemovexattrReq',
      '9': 0,
      '10': 'removexattr'
    },
    {
      '1': 'access',
      '3': 37,
      '4': 1,
      '5': 11,
      '6': '.bentos.fuse.AccessReq',
      '9': 0,
      '10': 'access'
    },
    {
      '1': 'create',
      '3': 38,
      '4': 1,
      '5': 11,
      '6': '.bentos.fuse.CreateReq',
      '9': 0,
      '10': 'create'
    },
    {
      '1': 'getlk',
      '3': 39,
      '4': 1,
      '5': 11,
      '6': '.bentos.fuse.GetlkReq',
      '9': 0,
      '10': 'getlk'
    },
    {
      '1': 'setlk',
      '3': 40,
      '4': 1,
      '5': 11,
      '6': '.bentos.fuse.SetlkReq',
      '9': 0,
      '10': 'setlk'
    },
    {
      '1': 'bmap',
      '3': 41,
      '4': 1,
      '5': 11,
      '6': '.bentos.fuse.BmapReq',
      '9': 0,
      '10': 'bmap'
    },
    {
      '1': 'fallocate',
      '3': 42,
      '4': 1,
      '5': 11,
      '6': '.bentos.fuse.FallocateReq',
      '9': 0,
      '10': 'fallocate'
    },
    {
      '1': 'readdirplus',
      '3': 43,
      '4': 1,
      '5': 11,
      '6': '.bentos.fuse.ReaddirplusReq',
      '9': 0,
      '10': 'readdirplus'
    },
    {
      '1': 'copy_file_range',
      '3': 44,
      '4': 1,
      '5': 11,
      '6': '.bentos.fuse.CopyFileRangeReq',
      '9': 0,
      '10': 'copyFileRange'
    },
    {
      '1': 'lseek',
      '3': 45,
      '4': 1,
      '5': 11,
      '6': '.bentos.fuse.LseekReq',
      '9': 0,
      '10': 'lseek'
    },
  ],
  '8': [
    {'1': 'op'},
  ],
};

/// Descriptor for `FuseRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List fuseRequestDescriptor = $convert.base64Decode(
    'CgtGdXNlUmVxdWVzdBIqCgRvcGVuGAEgASgLMhQuYmVudG9zLmZ1c2UuT3BlblJlcUgAUgRvcG'
    'VuEioKBHJlYWQYAiABKAsyFC5iZW50b3MuZnVzZS5SZWFkUmVxSABSBHJlYWQSLQoFd3JpdGUY'
    'AyABKAsyFS5iZW50b3MuZnVzZS5Xcml0ZVJlcUgAUgV3cml0ZRItCgVmbHVzaBgEIAEoCzIVLm'
    'JlbnRvcy5mdXNlLkZsdXNoUmVxSABSBWZsdXNoEjMKB3JlbGVhc2UYBSABKAsyFy5iZW50b3Mu'
    'ZnVzZS5SZWxlYXNlUmVxSABSB3JlbGVhc2USLQoFZnN5bmMYBiABKAsyFS5iZW50b3MuZnVzZS'
    '5Gc3luY1JlcUgAUgVmc3luYxItCgVpb2N0bBgHIAEoCzIVLmJlbnRvcy5mdXNlLklvY3RsUmVx'
    'SABSBWlvY3RsEioKBHBvbGwYCCABKAsyFC5iZW50b3MuZnVzZS5Qb2xsUmVxSABSBHBvbGwSMA'
    'oGbG9va3VwGBAgASgLMhYuYmVudG9zLmZ1c2UuTG9va3VwUmVxSABSBmxvb2t1cBIwCgZmb3Jn'
    'ZXQYESABKAsyFi5iZW50b3MuZnVzZS5Gb3JnZXRSZXFIAFIGZm9yZ2V0EjMKB2dldGF0dHIYEi'
    'ABKAsyFy5iZW50b3MuZnVzZS5HZXRhdHRyUmVxSABSB2dldGF0dHISMwoHc2V0YXR0chgTIAEo'
    'CzIXLmJlbnRvcy5mdXNlLlNldGF0dHJSZXFIAFIHc2V0YXR0chI2CghyZWFkbGluaxgUIAEoCz'
    'IYLmJlbnRvcy5mdXNlLlJlYWRsaW5rUmVxSABSCHJlYWRsaW5rEi0KBW1rbm9kGBUgASgLMhUu'
    'YmVudG9zLmZ1c2UuTWtub2RSZXFIAFIFbWtub2QSLQoFbWtkaXIYFiABKAsyFS5iZW50b3MuZn'
    'VzZS5Na2RpclJlcUgAUgVta2RpchIwCgZ1bmxpbmsYFyABKAsyFi5iZW50b3MuZnVzZS5Vbmxp'
    'bmtSZXFIAFIGdW5saW5rEi0KBXJtZGlyGBggASgLMhUuYmVudG9zLmZ1c2UuUm1kaXJSZXFIAF'
    'IFcm1kaXISMwoHc3ltbGluaxgZIAEoCzIXLmJlbnRvcy5mdXNlLlN5bWxpbmtSZXFIAFIHc3lt'
    'bGluaxIwCgZyZW5hbWUYGiABKAsyFi5iZW50b3MuZnVzZS5SZW5hbWVSZXFIAFIGcmVuYW1lEi'
    'oKBGxpbmsYGyABKAsyFC5iZW50b3MuZnVzZS5MaW5rUmVxSABSBGxpbmsSMwoHb3BlbmRpchgc'
    'IAEoCzIXLmJlbnRvcy5mdXNlLk9wZW5kaXJSZXFIAFIHb3BlbmRpchIzCgdyZWFkZGlyGB0gAS'
    'gLMhcuYmVudG9zLmZ1c2UuUmVhZGRpclJlcUgAUgdyZWFkZGlyEjwKCnJlbGVhc2VkaXIYHiAB'
    'KAsyGi5iZW50b3MuZnVzZS5SZWxlYXNlZGlyUmVxSABSCnJlbGVhc2VkaXISNgoIZnN5bmNkaX'
    'IYHyABKAsyGC5iZW50b3MuZnVzZS5Gc3luY2RpclJlcUgAUghmc3luY2RpchIwCgZzdGF0ZnMY'
    'ICABKAsyFi5iZW50b3MuZnVzZS5TdGF0ZnNSZXFIAFIGc3RhdGZzEjYKCHNldHhhdHRyGCEgAS'
    'gLMhguYmVudG9zLmZ1c2UuU2V0eGF0dHJSZXFIAFIIc2V0eGF0dHISNgoIZ2V0eGF0dHIYIiAB'
    'KAsyGC5iZW50b3MuZnVzZS5HZXR4YXR0clJlcUgAUghnZXR4YXR0chI5CglsaXN0eGF0dHIYIy'
    'ABKAsyGS5iZW50b3MuZnVzZS5MaXN0eGF0dHJSZXFIAFIJbGlzdHhhdHRyEj8KC3JlbW92ZXhh'
    'dHRyGCQgASgLMhsuYmVudG9zLmZ1c2UuUmVtb3ZleGF0dHJSZXFIAFILcmVtb3ZleGF0dHISMA'
    'oGYWNjZXNzGCUgASgLMhYuYmVudG9zLmZ1c2UuQWNjZXNzUmVxSABSBmFjY2VzcxIwCgZjcmVh'
    'dGUYJiABKAsyFi5iZW50b3MuZnVzZS5DcmVhdGVSZXFIAFIGY3JlYXRlEi0KBWdldGxrGCcgAS'
    'gLMhUuYmVudG9zLmZ1c2UuR2V0bGtSZXFIAFIFZ2V0bGsSLQoFc2V0bGsYKCABKAsyFS5iZW50'
    'b3MuZnVzZS5TZXRsa1JlcUgAUgVzZXRsaxIqCgRibWFwGCkgASgLMhQuYmVudG9zLmZ1c2UuQm'
    '1hcFJlcUgAUgRibWFwEjkKCWZhbGxvY2F0ZRgqIAEoCzIZLmJlbnRvcy5mdXNlLkZhbGxvY2F0'
    'ZVJlcUgAUglmYWxsb2NhdGUSPwoLcmVhZGRpcnBsdXMYKyABKAsyGy5iZW50b3MuZnVzZS5SZW'
    'FkZGlycGx1c1JlcUgAUgtyZWFkZGlycGx1cxJHCg9jb3B5X2ZpbGVfcmFuZ2UYLCABKAsyHS5i'
    'ZW50b3MuZnVzZS5Db3B5RmlsZVJhbmdlUmVxSABSDWNvcHlGaWxlUmFuZ2USLQoFbHNlZWsYLS'
    'ABKAsyFS5iZW50b3MuZnVzZS5Mc2Vla1JlcUgAUgVsc2Vla0IECgJvcA==');

@$core.Deprecated('Use openReqDescriptor instead')
const OpenReq$json = {
  '1': 'OpenReq',
  '2': [
    {'1': 'flags', '3': 1, '4': 1, '5': 5, '10': 'flags'},
  ],
};

/// Descriptor for `OpenReq`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List openReqDescriptor =
    $convert.base64Decode('CgdPcGVuUmVxEhQKBWZsYWdzGAEgASgFUgVmbGFncw==');

@$core.Deprecated('Use readReqDescriptor instead')
const ReadReq$json = {
  '1': 'ReadReq',
  '2': [
    {'1': 'size', '3': 1, '4': 1, '5': 4, '10': 'size'},
    {'1': 'offset', '3': 2, '4': 1, '5': 3, '10': 'offset'},
  ],
};

/// Descriptor for `ReadReq`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List readReqDescriptor = $convert.base64Decode(
    'CgdSZWFkUmVxEhIKBHNpemUYASABKARSBHNpemUSFgoGb2Zmc2V0GAIgASgDUgZvZmZzZXQ=');

@$core.Deprecated('Use writeReqDescriptor instead')
const WriteReq$json = {
  '1': 'WriteReq',
  '2': [
    {'1': 'data', '3': 1, '4': 1, '5': 12, '10': 'data'},
    {'1': 'offset', '3': 2, '4': 1, '5': 3, '10': 'offset'},
  ],
};

/// Descriptor for `WriteReq`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List writeReqDescriptor = $convert.base64Decode(
    'CghXcml0ZVJlcRISCgRkYXRhGAEgASgMUgRkYXRhEhYKBm9mZnNldBgCIAEoA1IGb2Zmc2V0');

@$core.Deprecated('Use flushReqDescriptor instead')
const FlushReq$json = {
  '1': 'FlushReq',
  '2': [
    {'1': 'lock_owner', '3': 1, '4': 1, '5': 4, '10': 'lockOwner'},
  ],
};

/// Descriptor for `FlushReq`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List flushReqDescriptor = $convert
    .base64Decode('CghGbHVzaFJlcRIdCgpsb2NrX293bmVyGAEgASgEUglsb2NrT3duZXI=');

@$core.Deprecated('Use releaseReqDescriptor instead')
const ReleaseReq$json = {
  '1': 'ReleaseReq',
  '2': [
    {'1': 'flags', '3': 1, '4': 1, '5': 5, '10': 'flags'},
    {'1': 'lock_owner', '3': 2, '4': 1, '5': 4, '10': 'lockOwner'},
  ],
};

/// Descriptor for `ReleaseReq`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List releaseReqDescriptor = $convert.base64Decode(
    'CgpSZWxlYXNlUmVxEhQKBWZsYWdzGAEgASgFUgVmbGFncxIdCgpsb2NrX293bmVyGAIgASgEUg'
    'lsb2NrT3duZXI=');

@$core.Deprecated('Use fsyncReqDescriptor instead')
const FsyncReq$json = {
  '1': 'FsyncReq',
  '2': [
    {'1': 'datasync', '3': 1, '4': 1, '5': 8, '10': 'datasync'},
  ],
};

/// Descriptor for `FsyncReq`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List fsyncReqDescriptor = $convert
    .base64Decode('CghGc3luY1JlcRIaCghkYXRhc3luYxgBIAEoCFIIZGF0YXN5bmM=');

@$core.Deprecated('Use ioctlReqDescriptor instead')
const IoctlReq$json = {
  '1': 'IoctlReq',
  '2': [
    {'1': 'cmd', '3': 1, '4': 1, '5': 13, '10': 'cmd'},
    {'1': 'flags', '3': 2, '4': 1, '5': 13, '10': 'flags'},
    {'1': 'in_buf', '3': 3, '4': 1, '5': 12, '10': 'inBuf'},
    {'1': 'out_bufsz', '3': 4, '4': 1, '5': 4, '10': 'outBufsz'},
  ],
};

/// Descriptor for `IoctlReq`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List ioctlReqDescriptor = $convert.base64Decode(
    'CghJb2N0bFJlcRIQCgNjbWQYASABKA1SA2NtZBIUCgVmbGFncxgCIAEoDVIFZmxhZ3MSFQoGaW'
    '5fYnVmGAMgASgMUgVpbkJ1ZhIbCglvdXRfYnVmc3oYBCABKARSCG91dEJ1ZnN6');

@$core.Deprecated('Use pollReqDescriptor instead')
const PollReq$json = {
  '1': 'PollReq',
  '2': [
    {'1': 'events', '3': 1, '4': 1, '5': 13, '10': 'events'},
    {'1': 'kh', '3': 2, '4': 1, '5': 4, '10': 'kh'},
  ],
};

/// Descriptor for `PollReq`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List pollReqDescriptor = $convert.base64Decode(
    'CgdQb2xsUmVxEhYKBmV2ZW50cxgBIAEoDVIGZXZlbnRzEg4KAmtoGAIgASgEUgJraA==');

@$core.Deprecated('Use lookupReqDescriptor instead')
const LookupReq$json = {
  '1': 'LookupReq',
  '2': [
    {'1': 'parent', '3': 1, '4': 1, '5': 4, '10': 'parent'},
    {'1': 'name', '3': 2, '4': 1, '5': 9, '10': 'name'},
  ],
};

/// Descriptor for `LookupReq`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List lookupReqDescriptor = $convert.base64Decode(
    'CglMb29rdXBSZXESFgoGcGFyZW50GAEgASgEUgZwYXJlbnQSEgoEbmFtZRgCIAEoCVIEbmFtZQ'
    '==');

@$core.Deprecated('Use forgetReqDescriptor instead')
const ForgetReq$json = {
  '1': 'ForgetReq',
  '2': [
    {'1': 'ino', '3': 1, '4': 1, '5': 4, '10': 'ino'},
    {'1': 'nlookup', '3': 2, '4': 1, '5': 4, '10': 'nlookup'},
  ],
};

/// Descriptor for `ForgetReq`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List forgetReqDescriptor = $convert.base64Decode(
    'CglGb3JnZXRSZXESEAoDaW5vGAEgASgEUgNpbm8SGAoHbmxvb2t1cBgCIAEoBFIHbmxvb2t1cA'
    '==');

@$core.Deprecated('Use getattrReqDescriptor instead')
const GetattrReq$json = {
  '1': 'GetattrReq',
  '2': [
    {'1': 'ino', '3': 1, '4': 1, '5': 4, '10': 'ino'},
  ],
};

/// Descriptor for `GetattrReq`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getattrReqDescriptor =
    $convert.base64Decode('CgpHZXRhdHRyUmVxEhAKA2lubxgBIAEoBFIDaW5v');

@$core.Deprecated('Use setattrReqDescriptor instead')
const SetattrReq$json = {
  '1': 'SetattrReq',
  '2': [
    {'1': 'ino', '3': 1, '4': 1, '5': 4, '10': 'ino'},
    {
      '1': 'attr',
      '3': 2,
      '4': 1,
      '5': 11,
      '6': '.bentos.fuse.StatAttr',
      '10': 'attr'
    },
    {'1': 'to_set', '3': 3, '4': 1, '5': 13, '10': 'toSet'},
  ],
};

/// Descriptor for `SetattrReq`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List setattrReqDescriptor = $convert.base64Decode(
    'CgpTZXRhdHRyUmVxEhAKA2lubxgBIAEoBFIDaW5vEikKBGF0dHIYAiABKAsyFS5iZW50b3MuZn'
    'VzZS5TdGF0QXR0clIEYXR0chIVCgZ0b19zZXQYAyABKA1SBXRvU2V0');

@$core.Deprecated('Use readlinkReqDescriptor instead')
const ReadlinkReq$json = {
  '1': 'ReadlinkReq',
  '2': [
    {'1': 'ino', '3': 1, '4': 1, '5': 4, '10': 'ino'},
  ],
};

/// Descriptor for `ReadlinkReq`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List readlinkReqDescriptor =
    $convert.base64Decode('CgtSZWFkbGlua1JlcRIQCgNpbm8YASABKARSA2lubw==');

@$core.Deprecated('Use mknodReqDescriptor instead')
const MknodReq$json = {
  '1': 'MknodReq',
  '2': [
    {'1': 'parent', '3': 1, '4': 1, '5': 4, '10': 'parent'},
    {'1': 'name', '3': 2, '4': 1, '5': 9, '10': 'name'},
    {'1': 'mode', '3': 3, '4': 1, '5': 13, '10': 'mode'},
    {'1': 'rdev', '3': 4, '4': 1, '5': 4, '10': 'rdev'},
  ],
};

/// Descriptor for `MknodReq`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List mknodReqDescriptor = $convert.base64Decode(
    'CghNa25vZFJlcRIWCgZwYXJlbnQYASABKARSBnBhcmVudBISCgRuYW1lGAIgASgJUgRuYW1lEh'
    'IKBG1vZGUYAyABKA1SBG1vZGUSEgoEcmRldhgEIAEoBFIEcmRldg==');

@$core.Deprecated('Use mkdirReqDescriptor instead')
const MkdirReq$json = {
  '1': 'MkdirReq',
  '2': [
    {'1': 'parent', '3': 1, '4': 1, '5': 4, '10': 'parent'},
    {'1': 'name', '3': 2, '4': 1, '5': 9, '10': 'name'},
    {'1': 'mode', '3': 3, '4': 1, '5': 13, '10': 'mode'},
  ],
};

/// Descriptor for `MkdirReq`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List mkdirReqDescriptor = $convert.base64Decode(
    'CghNa2RpclJlcRIWCgZwYXJlbnQYASABKARSBnBhcmVudBISCgRuYW1lGAIgASgJUgRuYW1lEh'
    'IKBG1vZGUYAyABKA1SBG1vZGU=');

@$core.Deprecated('Use unlinkReqDescriptor instead')
const UnlinkReq$json = {
  '1': 'UnlinkReq',
  '2': [
    {'1': 'parent', '3': 1, '4': 1, '5': 4, '10': 'parent'},
    {'1': 'name', '3': 2, '4': 1, '5': 9, '10': 'name'},
  ],
};

/// Descriptor for `UnlinkReq`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List unlinkReqDescriptor = $convert.base64Decode(
    'CglVbmxpbmtSZXESFgoGcGFyZW50GAEgASgEUgZwYXJlbnQSEgoEbmFtZRgCIAEoCVIEbmFtZQ'
    '==');

@$core.Deprecated('Use rmdirReqDescriptor instead')
const RmdirReq$json = {
  '1': 'RmdirReq',
  '2': [
    {'1': 'parent', '3': 1, '4': 1, '5': 4, '10': 'parent'},
    {'1': 'name', '3': 2, '4': 1, '5': 9, '10': 'name'},
  ],
};

/// Descriptor for `RmdirReq`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List rmdirReqDescriptor = $convert.base64Decode(
    'CghSbWRpclJlcRIWCgZwYXJlbnQYASABKARSBnBhcmVudBISCgRuYW1lGAIgASgJUgRuYW1l');

@$core.Deprecated('Use symlinkReqDescriptor instead')
const SymlinkReq$json = {
  '1': 'SymlinkReq',
  '2': [
    {'1': 'link', '3': 1, '4': 1, '5': 9, '10': 'link'},
    {'1': 'parent', '3': 2, '4': 1, '5': 4, '10': 'parent'},
    {'1': 'name', '3': 3, '4': 1, '5': 9, '10': 'name'},
  ],
};

/// Descriptor for `SymlinkReq`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List symlinkReqDescriptor = $convert.base64Decode(
    'CgpTeW1saW5rUmVxEhIKBGxpbmsYASABKAlSBGxpbmsSFgoGcGFyZW50GAIgASgEUgZwYXJlbn'
    'QSEgoEbmFtZRgDIAEoCVIEbmFtZQ==');

@$core.Deprecated('Use renameReqDescriptor instead')
const RenameReq$json = {
  '1': 'RenameReq',
  '2': [
    {'1': 'parent', '3': 1, '4': 1, '5': 4, '10': 'parent'},
    {'1': 'name', '3': 2, '4': 1, '5': 9, '10': 'name'},
    {'1': 'new_parent', '3': 3, '4': 1, '5': 4, '10': 'newParent'},
    {'1': 'new_name', '3': 4, '4': 1, '5': 9, '10': 'newName'},
    {'1': 'flags', '3': 5, '4': 1, '5': 13, '10': 'flags'},
  ],
};

/// Descriptor for `RenameReq`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List renameReqDescriptor = $convert.base64Decode(
    'CglSZW5hbWVSZXESFgoGcGFyZW50GAEgASgEUgZwYXJlbnQSEgoEbmFtZRgCIAEoCVIEbmFtZR'
    'IdCgpuZXdfcGFyZW50GAMgASgEUgluZXdQYXJlbnQSGQoIbmV3X25hbWUYBCABKAlSB25ld05h'
    'bWUSFAoFZmxhZ3MYBSABKA1SBWZsYWdz');

@$core.Deprecated('Use linkReqDescriptor instead')
const LinkReq$json = {
  '1': 'LinkReq',
  '2': [
    {'1': 'ino', '3': 1, '4': 1, '5': 4, '10': 'ino'},
    {'1': 'new_parent', '3': 2, '4': 1, '5': 4, '10': 'newParent'},
    {'1': 'new_name', '3': 3, '4': 1, '5': 9, '10': 'newName'},
  ],
};

/// Descriptor for `LinkReq`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List linkReqDescriptor = $convert.base64Decode(
    'CgdMaW5rUmVxEhAKA2lubxgBIAEoBFIDaW5vEh0KCm5ld19wYXJlbnQYAiABKARSCW5ld1Bhcm'
    'VudBIZCghuZXdfbmFtZRgDIAEoCVIHbmV3TmFtZQ==');

@$core.Deprecated('Use opendirReqDescriptor instead')
const OpendirReq$json = {
  '1': 'OpendirReq',
  '2': [
    {'1': 'ino', '3': 1, '4': 1, '5': 4, '10': 'ino'},
    {'1': 'flags', '3': 2, '4': 1, '5': 5, '10': 'flags'},
  ],
};

/// Descriptor for `OpendirReq`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List opendirReqDescriptor = $convert.base64Decode(
    'CgpPcGVuZGlyUmVxEhAKA2lubxgBIAEoBFIDaW5vEhQKBWZsYWdzGAIgASgFUgVmbGFncw==');

@$core.Deprecated('Use readdirReqDescriptor instead')
const ReaddirReq$json = {
  '1': 'ReaddirReq',
  '2': [
    {'1': 'ino', '3': 1, '4': 1, '5': 4, '10': 'ino'},
    {'1': 'size', '3': 2, '4': 1, '5': 4, '10': 'size'},
    {'1': 'offset', '3': 3, '4': 1, '5': 3, '10': 'offset'},
  ],
};

/// Descriptor for `ReaddirReq`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List readdirReqDescriptor = $convert.base64Decode(
    'CgpSZWFkZGlyUmVxEhAKA2lubxgBIAEoBFIDaW5vEhIKBHNpemUYAiABKARSBHNpemUSFgoGb2'
    'Zmc2V0GAMgASgDUgZvZmZzZXQ=');

@$core.Deprecated('Use releasedirReqDescriptor instead')
const ReleasedirReq$json = {
  '1': 'ReleasedirReq',
  '2': [
    {'1': 'ino', '3': 1, '4': 1, '5': 4, '10': 'ino'},
  ],
};

/// Descriptor for `ReleasedirReq`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List releasedirReqDescriptor =
    $convert.base64Decode('Cg1SZWxlYXNlZGlyUmVxEhAKA2lubxgBIAEoBFIDaW5v');

@$core.Deprecated('Use fsyncdirReqDescriptor instead')
const FsyncdirReq$json = {
  '1': 'FsyncdirReq',
  '2': [
    {'1': 'ino', '3': 1, '4': 1, '5': 4, '10': 'ino'},
    {'1': 'datasync', '3': 2, '4': 1, '5': 8, '10': 'datasync'},
  ],
};

/// Descriptor for `FsyncdirReq`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List fsyncdirReqDescriptor = $convert.base64Decode(
    'CgtGc3luY2RpclJlcRIQCgNpbm8YASABKARSA2lubxIaCghkYXRhc3luYxgCIAEoCFIIZGF0YX'
    'N5bmM=');

@$core.Deprecated('Use statfsReqDescriptor instead')
const StatfsReq$json = {
  '1': 'StatfsReq',
  '2': [
    {'1': 'ino', '3': 1, '4': 1, '5': 4, '10': 'ino'},
  ],
};

/// Descriptor for `StatfsReq`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List statfsReqDescriptor =
    $convert.base64Decode('CglTdGF0ZnNSZXESEAoDaW5vGAEgASgEUgNpbm8=');

@$core.Deprecated('Use setxattrReqDescriptor instead')
const SetxattrReq$json = {
  '1': 'SetxattrReq',
  '2': [
    {'1': 'ino', '3': 1, '4': 1, '5': 4, '10': 'ino'},
    {'1': 'name', '3': 2, '4': 1, '5': 9, '10': 'name'},
    {'1': 'value', '3': 3, '4': 1, '5': 12, '10': 'value'},
    {'1': 'flags', '3': 4, '4': 1, '5': 13, '10': 'flags'},
  ],
};

/// Descriptor for `SetxattrReq`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List setxattrReqDescriptor = $convert.base64Decode(
    'CgtTZXR4YXR0clJlcRIQCgNpbm8YASABKARSA2lubxISCgRuYW1lGAIgASgJUgRuYW1lEhQKBX'
    'ZhbHVlGAMgASgMUgV2YWx1ZRIUCgVmbGFncxgEIAEoDVIFZmxhZ3M=');

@$core.Deprecated('Use getxattrReqDescriptor instead')
const GetxattrReq$json = {
  '1': 'GetxattrReq',
  '2': [
    {'1': 'ino', '3': 1, '4': 1, '5': 4, '10': 'ino'},
    {'1': 'name', '3': 2, '4': 1, '5': 9, '10': 'name'},
    {'1': 'size', '3': 3, '4': 1, '5': 4, '10': 'size'},
  ],
};

/// Descriptor for `GetxattrReq`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getxattrReqDescriptor = $convert.base64Decode(
    'CgtHZXR4YXR0clJlcRIQCgNpbm8YASABKARSA2lubxISCgRuYW1lGAIgASgJUgRuYW1lEhIKBH'
    'NpemUYAyABKARSBHNpemU=');

@$core.Deprecated('Use listxattrReqDescriptor instead')
const ListxattrReq$json = {
  '1': 'ListxattrReq',
  '2': [
    {'1': 'ino', '3': 1, '4': 1, '5': 4, '10': 'ino'},
    {'1': 'size', '3': 2, '4': 1, '5': 4, '10': 'size'},
  ],
};

/// Descriptor for `ListxattrReq`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listxattrReqDescriptor = $convert.base64Decode(
    'CgxMaXN0eGF0dHJSZXESEAoDaW5vGAEgASgEUgNpbm8SEgoEc2l6ZRgCIAEoBFIEc2l6ZQ==');

@$core.Deprecated('Use removexattrReqDescriptor instead')
const RemovexattrReq$json = {
  '1': 'RemovexattrReq',
  '2': [
    {'1': 'ino', '3': 1, '4': 1, '5': 4, '10': 'ino'},
    {'1': 'name', '3': 2, '4': 1, '5': 9, '10': 'name'},
  ],
};

/// Descriptor for `RemovexattrReq`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List removexattrReqDescriptor = $convert.base64Decode(
    'Cg5SZW1vdmV4YXR0clJlcRIQCgNpbm8YASABKARSA2lubxISCgRuYW1lGAIgASgJUgRuYW1l');

@$core.Deprecated('Use accessReqDescriptor instead')
const AccessReq$json = {
  '1': 'AccessReq',
  '2': [
    {'1': 'ino', '3': 1, '4': 1, '5': 4, '10': 'ino'},
    {'1': 'mask', '3': 2, '4': 1, '5': 5, '10': 'mask'},
  ],
};

/// Descriptor for `AccessReq`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List accessReqDescriptor = $convert.base64Decode(
    'CglBY2Nlc3NSZXESEAoDaW5vGAEgASgEUgNpbm8SEgoEbWFzaxgCIAEoBVIEbWFzaw==');

@$core.Deprecated('Use createReqDescriptor instead')
const CreateReq$json = {
  '1': 'CreateReq',
  '2': [
    {'1': 'parent', '3': 1, '4': 1, '5': 4, '10': 'parent'},
    {'1': 'name', '3': 2, '4': 1, '5': 9, '10': 'name'},
    {'1': 'mode', '3': 3, '4': 1, '5': 13, '10': 'mode'},
    {'1': 'flags', '3': 4, '4': 1, '5': 5, '10': 'flags'},
  ],
};

/// Descriptor for `CreateReq`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List createReqDescriptor = $convert.base64Decode(
    'CglDcmVhdGVSZXESFgoGcGFyZW50GAEgASgEUgZwYXJlbnQSEgoEbmFtZRgCIAEoCVIEbmFtZR'
    'ISCgRtb2RlGAMgASgNUgRtb2RlEhQKBWZsYWdzGAQgASgFUgVmbGFncw==');

@$core.Deprecated('Use getlkReqDescriptor instead')
const GetlkReq$json = {
  '1': 'GetlkReq',
  '2': [
    {'1': 'ino', '3': 1, '4': 1, '5': 4, '10': 'ino'},
    {
      '1': 'lock',
      '3': 2,
      '4': 1,
      '5': 11,
      '6': '.bentos.fuse.FlockInfo',
      '10': 'lock'
    },
  ],
};

/// Descriptor for `GetlkReq`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getlkReqDescriptor = $convert.base64Decode(
    'CghHZXRsa1JlcRIQCgNpbm8YASABKARSA2lubxIqCgRsb2NrGAIgASgLMhYuYmVudG9zLmZ1c2'
    'UuRmxvY2tJbmZvUgRsb2Nr');

@$core.Deprecated('Use setlkReqDescriptor instead')
const SetlkReq$json = {
  '1': 'SetlkReq',
  '2': [
    {'1': 'ino', '3': 1, '4': 1, '5': 4, '10': 'ino'},
    {
      '1': 'lock',
      '3': 2,
      '4': 1,
      '5': 11,
      '6': '.bentos.fuse.FlockInfo',
      '10': 'lock'
    },
    {'1': 'sleep', '3': 3, '4': 1, '5': 8, '10': 'sleep'},
  ],
};

/// Descriptor for `SetlkReq`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List setlkReqDescriptor = $convert.base64Decode(
    'CghTZXRsa1JlcRIQCgNpbm8YASABKARSA2lubxIqCgRsb2NrGAIgASgLMhYuYmVudG9zLmZ1c2'
    'UuRmxvY2tJbmZvUgRsb2NrEhQKBXNsZWVwGAMgASgIUgVzbGVlcA==');

@$core.Deprecated('Use bmapReqDescriptor instead')
const BmapReq$json = {
  '1': 'BmapReq',
  '2': [
    {'1': 'ino', '3': 1, '4': 1, '5': 4, '10': 'ino'},
    {'1': 'blocksize', '3': 2, '4': 1, '5': 4, '10': 'blocksize'},
    {'1': 'idx', '3': 3, '4': 1, '5': 4, '10': 'idx'},
  ],
};

/// Descriptor for `BmapReq`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List bmapReqDescriptor = $convert.base64Decode(
    'CgdCbWFwUmVxEhAKA2lubxgBIAEoBFIDaW5vEhwKCWJsb2Nrc2l6ZRgCIAEoBFIJYmxvY2tzaX'
    'plEhAKA2lkeBgDIAEoBFIDaWR4');

@$core.Deprecated('Use fallocateReqDescriptor instead')
const FallocateReq$json = {
  '1': 'FallocateReq',
  '2': [
    {'1': 'ino', '3': 1, '4': 1, '5': 4, '10': 'ino'},
    {'1': 'mode', '3': 2, '4': 1, '5': 5, '10': 'mode'},
    {'1': 'offset', '3': 3, '4': 1, '5': 3, '10': 'offset'},
    {'1': 'length', '3': 4, '4': 1, '5': 3, '10': 'length'},
  ],
};

/// Descriptor for `FallocateReq`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List fallocateReqDescriptor = $convert.base64Decode(
    'CgxGYWxsb2NhdGVSZXESEAoDaW5vGAEgASgEUgNpbm8SEgoEbW9kZRgCIAEoBVIEbW9kZRIWCg'
    'ZvZmZzZXQYAyABKANSBm9mZnNldBIWCgZsZW5ndGgYBCABKANSBmxlbmd0aA==');

@$core.Deprecated('Use readdirplusReqDescriptor instead')
const ReaddirplusReq$json = {
  '1': 'ReaddirplusReq',
  '2': [
    {'1': 'ino', '3': 1, '4': 1, '5': 4, '10': 'ino'},
    {'1': 'size', '3': 2, '4': 1, '5': 4, '10': 'size'},
    {'1': 'offset', '3': 3, '4': 1, '5': 3, '10': 'offset'},
  ],
};

/// Descriptor for `ReaddirplusReq`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List readdirplusReqDescriptor = $convert.base64Decode(
    'Cg5SZWFkZGlycGx1c1JlcRIQCgNpbm8YASABKARSA2lubxISCgRzaXplGAIgASgEUgRzaXplEh'
    'YKBm9mZnNldBgDIAEoA1IGb2Zmc2V0');

@$core.Deprecated('Use copyFileRangeReqDescriptor instead')
const CopyFileRangeReq$json = {
  '1': 'CopyFileRangeReq',
  '2': [
    {'1': 'ino_in', '3': 1, '4': 1, '5': 4, '10': 'inoIn'},
    {'1': 'off_in', '3': 2, '4': 1, '5': 3, '10': 'offIn'},
    {'1': 'ino_out', '3': 3, '4': 1, '5': 4, '10': 'inoOut'},
    {'1': 'off_out', '3': 4, '4': 1, '5': 3, '10': 'offOut'},
    {'1': 'len', '3': 5, '4': 1, '5': 4, '10': 'len'},
    {'1': 'flags', '3': 6, '4': 1, '5': 4, '10': 'flags'},
    {'1': 'fh_in', '3': 7, '4': 1, '5': 4, '10': 'fhIn'},
    {'1': 'fh_out', '3': 8, '4': 1, '5': 4, '10': 'fhOut'},
  ],
};

/// Descriptor for `CopyFileRangeReq`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List copyFileRangeReqDescriptor = $convert.base64Decode(
    'ChBDb3B5RmlsZVJhbmdlUmVxEhUKBmlub19pbhgBIAEoBFIFaW5vSW4SFQoGb2ZmX2luGAIgAS'
    'gDUgVvZmZJbhIXCgdpbm9fb3V0GAMgASgEUgZpbm9PdXQSFwoHb2ZmX291dBgEIAEoA1IGb2Zm'
    'T3V0EhAKA2xlbhgFIAEoBFIDbGVuEhQKBWZsYWdzGAYgASgEUgVmbGFncxITCgVmaF9pbhgHIA'
    'EoBFIEZmhJbhIVCgZmaF9vdXQYCCABKARSBWZoT3V0');

@$core.Deprecated('Use lseekReqDescriptor instead')
const LseekReq$json = {
  '1': 'LseekReq',
  '2': [
    {'1': 'offset', '3': 1, '4': 1, '5': 3, '10': 'offset'},
    {'1': 'whence', '3': 2, '4': 1, '5': 5, '10': 'whence'},
  ],
};

/// Descriptor for `LseekReq`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List lseekReqDescriptor = $convert.base64Decode(
    'CghMc2Vla1JlcRIWCgZvZmZzZXQYASABKANSBm9mZnNldBIWCgZ3aGVuY2UYAiABKAVSBndoZW'
    '5jZQ==');

@$core.Deprecated('Use fuseResponseDescriptor instead')
const FuseResponse$json = {
  '1': 'FuseResponse',
  '2': [
    {'1': 'err', '3': 1, '4': 1, '5': 5, '10': 'err'},
    {
      '1': 'open',
      '3': 8,
      '4': 1,
      '5': 11,
      '6': '.bentos.fuse.OpenReply',
      '9': 0,
      '10': 'open'
    },
    {
      '1': 'buf',
      '3': 9,
      '4': 1,
      '5': 11,
      '6': '.bentos.fuse.BufReply',
      '9': 0,
      '10': 'buf'
    },
    {
      '1': 'write',
      '3': 10,
      '4': 1,
      '5': 11,
      '6': '.bentos.fuse.WriteReply',
      '9': 0,
      '10': 'write'
    },
    {
      '1': 'ioctl',
      '3': 11,
      '4': 1,
      '5': 11,
      '6': '.bentos.fuse.IoctlReply',
      '9': 0,
      '10': 'ioctl'
    },
    {
      '1': 'poll',
      '3': 12,
      '4': 1,
      '5': 11,
      '6': '.bentos.fuse.PollReply',
      '9': 0,
      '10': 'poll'
    },
    {
      '1': 'entry',
      '3': 16,
      '4': 1,
      '5': 11,
      '6': '.bentos.fuse.EntryReply',
      '9': 0,
      '10': 'entry'
    },
    {
      '1': 'attr',
      '3': 17,
      '4': 1,
      '5': 11,
      '6': '.bentos.fuse.AttrReply',
      '9': 0,
      '10': 'attr'
    },
    {
      '1': 'readlink',
      '3': 18,
      '4': 1,
      '5': 11,
      '6': '.bentos.fuse.ReadlinkReply',
      '9': 0,
      '10': 'readlink'
    },
    {
      '1': 'statfs',
      '3': 19,
      '4': 1,
      '5': 11,
      '6': '.bentos.fuse.StatfsReply',
      '9': 0,
      '10': 'statfs'
    },
    {
      '1': 'xattr',
      '3': 20,
      '4': 1,
      '5': 11,
      '6': '.bentos.fuse.XattrReply',
      '9': 0,
      '10': 'xattr'
    },
    {
      '1': 'create',
      '3': 21,
      '4': 1,
      '5': 11,
      '6': '.bentos.fuse.CreateReply',
      '9': 0,
      '10': 'create'
    },
    {
      '1': 'lock',
      '3': 22,
      '4': 1,
      '5': 11,
      '6': '.bentos.fuse.LockReply',
      '9': 0,
      '10': 'lock'
    },
    {
      '1': 'bmap',
      '3': 23,
      '4': 1,
      '5': 11,
      '6': '.bentos.fuse.BmapReply',
      '9': 0,
      '10': 'bmap'
    },
    {
      '1': 'lseek',
      '3': 24,
      '4': 1,
      '5': 11,
      '6': '.bentos.fuse.LseekReply',
      '9': 0,
      '10': 'lseek'
    },
    {
      '1': 'readdir',
      '3': 25,
      '4': 1,
      '5': 11,
      '6': '.bentos.fuse.ReaddirReply',
      '9': 0,
      '10': 'readdir'
    },
  ],
  '8': [
    {'1': 'reply'},
  ],
};

/// Descriptor for `FuseResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List fuseResponseDescriptor = $convert.base64Decode(
    'CgxGdXNlUmVzcG9uc2USEAoDZXJyGAEgASgFUgNlcnISLAoEb3BlbhgIIAEoCzIWLmJlbnRvcy'
    '5mdXNlLk9wZW5SZXBseUgAUgRvcGVuEikKA2J1ZhgJIAEoCzIVLmJlbnRvcy5mdXNlLkJ1ZlJl'
    'cGx5SABSA2J1ZhIvCgV3cml0ZRgKIAEoCzIXLmJlbnRvcy5mdXNlLldyaXRlUmVwbHlIAFIFd3'
    'JpdGUSLwoFaW9jdGwYCyABKAsyFy5iZW50b3MuZnVzZS5Jb2N0bFJlcGx5SABSBWlvY3RsEiwK'
    'BHBvbGwYDCABKAsyFi5iZW50b3MuZnVzZS5Qb2xsUmVwbHlIAFIEcG9sbBIvCgVlbnRyeRgQIA'
    'EoCzIXLmJlbnRvcy5mdXNlLkVudHJ5UmVwbHlIAFIFZW50cnkSLAoEYXR0chgRIAEoCzIWLmJl'
    'bnRvcy5mdXNlLkF0dHJSZXBseUgAUgRhdHRyEjgKCHJlYWRsaW5rGBIgASgLMhouYmVudG9zLm'
    'Z1c2UuUmVhZGxpbmtSZXBseUgAUghyZWFkbGluaxIyCgZzdGF0ZnMYEyABKAsyGC5iZW50b3Mu'
    'ZnVzZS5TdGF0ZnNSZXBseUgAUgZzdGF0ZnMSLwoFeGF0dHIYFCABKAsyFy5iZW50b3MuZnVzZS'
    '5YYXR0clJlcGx5SABSBXhhdHRyEjIKBmNyZWF0ZRgVIAEoCzIYLmJlbnRvcy5mdXNlLkNyZWF0'
    'ZVJlcGx5SABSBmNyZWF0ZRIsCgRsb2NrGBYgASgLMhYuYmVudG9zLmZ1c2UuTG9ja1JlcGx5SA'
    'BSBGxvY2sSLAoEYm1hcBgXIAEoCzIWLmJlbnRvcy5mdXNlLkJtYXBSZXBseUgAUgRibWFwEi8K'
    'BWxzZWVrGBggASgLMhcuYmVudG9zLmZ1c2UuTHNlZWtSZXBseUgAUgVsc2VlaxI1CgdyZWFkZG'
    'lyGBkgASgLMhkuYmVudG9zLmZ1c2UuUmVhZGRpclJlcGx5SABSB3JlYWRkaXJCBwoFcmVwbHk=');

@$core.Deprecated('Use openReplyDescriptor instead')
const OpenReply$json = {
  '1': 'OpenReply',
  '2': [
    {'1': 'flags', '3': 1, '4': 1, '5': 5, '10': 'flags'},
    {'1': 'bitfields', '3': 2, '4': 1, '5': 13, '10': 'bitfields'},
  ],
};

/// Descriptor for `OpenReply`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List openReplyDescriptor = $convert.base64Decode(
    'CglPcGVuUmVwbHkSFAoFZmxhZ3MYASABKAVSBWZsYWdzEhwKCWJpdGZpZWxkcxgCIAEoDVIJYm'
    'l0ZmllbGRz');

@$core.Deprecated('Use bufReplyDescriptor instead')
const BufReply$json = {
  '1': 'BufReply',
  '2': [
    {'1': 'data', '3': 1, '4': 1, '5': 12, '10': 'data'},
  ],
};

/// Descriptor for `BufReply`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List bufReplyDescriptor =
    $convert.base64Decode('CghCdWZSZXBseRISCgRkYXRhGAEgASgMUgRkYXRh');

@$core.Deprecated('Use writeReplyDescriptor instead')
const WriteReply$json = {
  '1': 'WriteReply',
  '2': [
    {'1': 'count', '3': 1, '4': 1, '5': 4, '10': 'count'},
  ],
};

/// Descriptor for `WriteReply`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List writeReplyDescriptor =
    $convert.base64Decode('CgpXcml0ZVJlcGx5EhQKBWNvdW50GAEgASgEUgVjb3VudA==');

@$core.Deprecated('Use ioctlReplyDescriptor instead')
const IoctlReply$json = {
  '1': 'IoctlReply',
  '2': [
    {'1': 'result', '3': 1, '4': 1, '5': 5, '10': 'result'},
    {'1': 'buf', '3': 2, '4': 1, '5': 12, '10': 'buf'},
  ],
};

/// Descriptor for `IoctlReply`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List ioctlReplyDescriptor = $convert.base64Decode(
    'CgpJb2N0bFJlcGx5EhYKBnJlc3VsdBgBIAEoBVIGcmVzdWx0EhAKA2J1ZhgCIAEoDFIDYnVm');

@$core.Deprecated('Use pollReplyDescriptor instead')
const PollReply$json = {
  '1': 'PollReply',
  '2': [
    {'1': 'revents', '3': 1, '4': 1, '5': 13, '10': 'revents'},
  ],
};

/// Descriptor for `PollReply`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List pollReplyDescriptor = $convert
    .base64Decode('CglQb2xsUmVwbHkSGAoHcmV2ZW50cxgBIAEoDVIHcmV2ZW50cw==');

@$core.Deprecated('Use entryReplyDescriptor instead')
const EntryReply$json = {
  '1': 'EntryReply',
  '2': [
    {'1': 'ino', '3': 1, '4': 1, '5': 4, '10': 'ino'},
    {'1': 'generation', '3': 2, '4': 1, '5': 4, '10': 'generation'},
    {
      '1': 'attr',
      '3': 3,
      '4': 1,
      '5': 11,
      '6': '.bentos.fuse.StatAttr',
      '10': 'attr'
    },
    {'1': 'attr_timeout', '3': 4, '4': 1, '5': 1, '10': 'attrTimeout'},
    {'1': 'entry_timeout', '3': 5, '4': 1, '5': 1, '10': 'entryTimeout'},
  ],
};

/// Descriptor for `EntryReply`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List entryReplyDescriptor = $convert.base64Decode(
    'CgpFbnRyeVJlcGx5EhAKA2lubxgBIAEoBFIDaW5vEh4KCmdlbmVyYXRpb24YAiABKARSCmdlbm'
    'VyYXRpb24SKQoEYXR0chgDIAEoCzIVLmJlbnRvcy5mdXNlLlN0YXRBdHRyUgRhdHRyEiEKDGF0'
    'dHJfdGltZW91dBgEIAEoAVILYXR0clRpbWVvdXQSIwoNZW50cnlfdGltZW91dBgFIAEoAVIMZW'
    '50cnlUaW1lb3V0');

@$core.Deprecated('Use attrReplyDescriptor instead')
const AttrReply$json = {
  '1': 'AttrReply',
  '2': [
    {
      '1': 'attr',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.bentos.fuse.StatAttr',
      '10': 'attr'
    },
    {'1': 'attr_timeout', '3': 2, '4': 1, '5': 1, '10': 'attrTimeout'},
  ],
};

/// Descriptor for `AttrReply`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List attrReplyDescriptor = $convert.base64Decode(
    'CglBdHRyUmVwbHkSKQoEYXR0chgBIAEoCzIVLmJlbnRvcy5mdXNlLlN0YXRBdHRyUgRhdHRyEi'
    'EKDGF0dHJfdGltZW91dBgCIAEoAVILYXR0clRpbWVvdXQ=');

@$core.Deprecated('Use readlinkReplyDescriptor instead')
const ReadlinkReply$json = {
  '1': 'ReadlinkReply',
  '2': [
    {'1': 'link', '3': 1, '4': 1, '5': 9, '10': 'link'},
  ],
};

/// Descriptor for `ReadlinkReply`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List readlinkReplyDescriptor =
    $convert.base64Decode('Cg1SZWFkbGlua1JlcGx5EhIKBGxpbmsYASABKAlSBGxpbms=');

@$core.Deprecated('Use statfsReplyDescriptor instead')
const StatfsReply$json = {
  '1': 'StatfsReply',
  '2': [
    {'1': 'blocks', '3': 1, '4': 1, '5': 4, '10': 'blocks'},
    {'1': 'bfree', '3': 2, '4': 1, '5': 4, '10': 'bfree'},
    {'1': 'bavail', '3': 3, '4': 1, '5': 4, '10': 'bavail'},
    {'1': 'files', '3': 4, '4': 1, '5': 4, '10': 'files'},
    {'1': 'ffree', '3': 5, '4': 1, '5': 4, '10': 'ffree'},
    {'1': 'bsize', '3': 6, '4': 1, '5': 4, '10': 'bsize'},
    {'1': 'namelen', '3': 7, '4': 1, '5': 4, '10': 'namelen'},
    {'1': 'frsize', '3': 8, '4': 1, '5': 4, '10': 'frsize'},
  ],
};

/// Descriptor for `StatfsReply`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List statfsReplyDescriptor = $convert.base64Decode(
    'CgtTdGF0ZnNSZXBseRIWCgZibG9ja3MYASABKARSBmJsb2NrcxIUCgViZnJlZRgCIAEoBFIFYm'
    'ZyZWUSFgoGYmF2YWlsGAMgASgEUgZiYXZhaWwSFAoFZmlsZXMYBCABKARSBWZpbGVzEhQKBWZm'
    'cmVlGAUgASgEUgVmZnJlZRIUCgVic2l6ZRgGIAEoBFIFYnNpemUSGAoHbmFtZWxlbhgHIAEoBF'
    'IHbmFtZWxlbhIWCgZmcnNpemUYCCABKARSBmZyc2l6ZQ==');

@$core.Deprecated('Use xattrReplyDescriptor instead')
const XattrReply$json = {
  '1': 'XattrReply',
  '2': [
    {'1': 'count', '3': 1, '4': 1, '5': 4, '10': 'count'},
    {'1': 'data', '3': 2, '4': 1, '5': 12, '10': 'data'},
  ],
};

/// Descriptor for `XattrReply`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List xattrReplyDescriptor = $convert.base64Decode(
    'CgpYYXR0clJlcGx5EhQKBWNvdW50GAEgASgEUgVjb3VudBISCgRkYXRhGAIgASgMUgRkYXRh');

@$core.Deprecated('Use createReplyDescriptor instead')
const CreateReply$json = {
  '1': 'CreateReply',
  '2': [
    {
      '1': 'entry',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.bentos.fuse.EntryReply',
      '10': 'entry'
    },
    {
      '1': 'open_info',
      '3': 2,
      '4': 1,
      '5': 11,
      '6': '.bentos.fuse.OpenReply',
      '10': 'openInfo'
    },
  ],
};

/// Descriptor for `CreateReply`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List createReplyDescriptor = $convert.base64Decode(
    'CgtDcmVhdGVSZXBseRItCgVlbnRyeRgBIAEoCzIXLmJlbnRvcy5mdXNlLkVudHJ5UmVwbHlSBW'
    'VudHJ5EjMKCW9wZW5faW5mbxgCIAEoCzIWLmJlbnRvcy5mdXNlLk9wZW5SZXBseVIIb3Blbklu'
    'Zm8=');

@$core.Deprecated('Use lockReplyDescriptor instead')
const LockReply$json = {
  '1': 'LockReply',
  '2': [
    {
      '1': 'lock',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.bentos.fuse.FlockInfo',
      '10': 'lock'
    },
  ],
};

/// Descriptor for `LockReply`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List lockReplyDescriptor = $convert.base64Decode(
    'CglMb2NrUmVwbHkSKgoEbG9jaxgBIAEoCzIWLmJlbnRvcy5mdXNlLkZsb2NrSW5mb1IEbG9jaw'
    '==');

@$core.Deprecated('Use bmapReplyDescriptor instead')
const BmapReply$json = {
  '1': 'BmapReply',
  '2': [
    {'1': 'idx', '3': 1, '4': 1, '5': 4, '10': 'idx'},
  ],
};

/// Descriptor for `BmapReply`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List bmapReplyDescriptor =
    $convert.base64Decode('CglCbWFwUmVwbHkSEAoDaWR4GAEgASgEUgNpZHg=');

@$core.Deprecated('Use lseekReplyDescriptor instead')
const LseekReply$json = {
  '1': 'LseekReply',
  '2': [
    {'1': 'offset', '3': 1, '4': 1, '5': 3, '10': 'offset'},
  ],
};

/// Descriptor for `LseekReply`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List lseekReplyDescriptor =
    $convert.base64Decode('CgpMc2Vla1JlcGx5EhYKBm9mZnNldBgBIAEoA1IGb2Zmc2V0');

@$core.Deprecated('Use readdirReplyDescriptor instead')
const ReaddirReply$json = {
  '1': 'ReaddirReply',
  '2': [
    {
      '1': 'entries',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.bentos.fuse.ReaddirEntry',
      '10': 'entries'
    },
  ],
};

/// Descriptor for `ReaddirReply`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List readdirReplyDescriptor = $convert.base64Decode(
    'CgxSZWFkZGlyUmVwbHkSMwoHZW50cmllcxgBIAMoCzIZLmJlbnRvcy5mdXNlLlJlYWRkaXJFbn'
    'RyeVIHZW50cmllcw==');

@$core.Deprecated('Use readdirEntryDescriptor instead')
const ReaddirEntry$json = {
  '1': 'ReaddirEntry',
  '2': [
    {'1': 'name', '3': 1, '4': 1, '5': 9, '10': 'name'},
    {'1': 'ino', '3': 2, '4': 1, '5': 4, '10': 'ino'},
    {'1': 'mode', '3': 3, '4': 1, '5': 13, '10': 'mode'},
    {'1': 'offset', '3': 4, '4': 1, '5': 3, '10': 'offset'},
    {
      '1': 'attr',
      '3': 5,
      '4': 1,
      '5': 11,
      '6': '.bentos.fuse.StatAttr',
      '10': 'attr'
    },
    {'1': 'attr_timeout', '3': 6, '4': 1, '5': 1, '10': 'attrTimeout'},
    {'1': 'entry_timeout', '3': 7, '4': 1, '5': 1, '10': 'entryTimeout'},
  ],
};

/// Descriptor for `ReaddirEntry`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List readdirEntryDescriptor = $convert.base64Decode(
    'CgxSZWFkZGlyRW50cnkSEgoEbmFtZRgBIAEoCVIEbmFtZRIQCgNpbm8YAiABKARSA2lubxISCg'
    'Rtb2RlGAMgASgNUgRtb2RlEhYKBm9mZnNldBgEIAEoA1IGb2Zmc2V0EikKBGF0dHIYBSABKAsy'
    'FS5iZW50b3MuZnVzZS5TdGF0QXR0clIEYXR0chIhCgxhdHRyX3RpbWVvdXQYBiABKAFSC2F0dH'
    'JUaW1lb3V0EiMKDWVudHJ5X3RpbWVvdXQYByABKAFSDGVudHJ5VGltZW91dA==');

@$core.Deprecated('Use statAttrDescriptor instead')
const StatAttr$json = {
  '1': 'StatAttr',
  '2': [
    {'1': 'ino', '3': 1, '4': 1, '5': 4, '10': 'ino'},
    {'1': 'size', '3': 2, '4': 1, '5': 4, '10': 'size'},
    {'1': 'blocks', '3': 3, '4': 1, '5': 4, '10': 'blocks'},
    {'1': 'atime', '3': 4, '4': 1, '5': 3, '10': 'atime'},
    {'1': 'atime_ns', '3': 5, '4': 1, '5': 13, '10': 'atimeNs'},
    {'1': 'mtime', '3': 6, '4': 1, '5': 3, '10': 'mtime'},
    {'1': 'mtime_ns', '3': 7, '4': 1, '5': 13, '10': 'mtimeNs'},
    {'1': 'ctime', '3': 8, '4': 1, '5': 3, '10': 'ctime'},
    {'1': 'ctime_ns', '3': 9, '4': 1, '5': 13, '10': 'ctimeNs'},
    {'1': 'mode', '3': 10, '4': 1, '5': 13, '10': 'mode'},
    {'1': 'nlink', '3': 11, '4': 1, '5': 13, '10': 'nlink'},
    {'1': 'uid', '3': 12, '4': 1, '5': 13, '10': 'uid'},
    {'1': 'gid', '3': 13, '4': 1, '5': 13, '10': 'gid'},
    {'1': 'rdev', '3': 14, '4': 1, '5': 4, '10': 'rdev'},
    {'1': 'blksize', '3': 15, '4': 1, '5': 4, '10': 'blksize'},
  ],
};

/// Descriptor for `StatAttr`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List statAttrDescriptor = $convert.base64Decode(
    'CghTdGF0QXR0chIQCgNpbm8YASABKARSA2lubxISCgRzaXplGAIgASgEUgRzaXplEhYKBmJsb2'
    'NrcxgDIAEoBFIGYmxvY2tzEhQKBWF0aW1lGAQgASgDUgVhdGltZRIZCghhdGltZV9ucxgFIAEo'
    'DVIHYXRpbWVOcxIUCgVtdGltZRgGIAEoA1IFbXRpbWUSGQoIbXRpbWVfbnMYByABKA1SB210aW'
    '1lTnMSFAoFY3RpbWUYCCABKANSBWN0aW1lEhkKCGN0aW1lX25zGAkgASgNUgdjdGltZU5zEhIK'
    'BG1vZGUYCiABKA1SBG1vZGUSFAoFbmxpbmsYCyABKA1SBW5saW5rEhAKA3VpZBgMIAEoDVIDdW'
    'lkEhAKA2dpZBgNIAEoDVIDZ2lkEhIKBHJkZXYYDiABKARSBHJkZXYSGAoHYmxrc2l6ZRgPIAEo'
    'BFIHYmxrc2l6ZQ==');

@$core.Deprecated('Use flockInfoDescriptor instead')
const FlockInfo$json = {
  '1': 'FlockInfo',
  '2': [
    {'1': 'type', '3': 1, '4': 1, '5': 5, '10': 'type'},
    {'1': 'whence', '3': 2, '4': 1, '5': 5, '10': 'whence'},
    {'1': 'start', '3': 3, '4': 1, '5': 3, '10': 'start'},
    {'1': 'len', '3': 4, '4': 1, '5': 3, '10': 'len'},
    {'1': 'pid', '3': 5, '4': 1, '5': 5, '10': 'pid'},
  ],
};

/// Descriptor for `FlockInfo`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List flockInfoDescriptor = $convert.base64Decode(
    'CglGbG9ja0luZm8SEgoEdHlwZRgBIAEoBVIEdHlwZRIWCgZ3aGVuY2UYAiABKAVSBndoZW5jZR'
    'IUCgVzdGFydBgDIAEoA1IFc3RhcnQSEAoDbGVuGAQgASgDUgNsZW4SEAoDcGlkGAUgASgFUgNw'
    'aWQ=');
