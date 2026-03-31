// This is a generated file - do not edit.
//
// Generated from fuse_wire.proto.

// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names
// ignore_for_file: curly_braces_in_flow_control_structures
// ignore_for_file: deprecated_member_use_from_same_package, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_relative_imports

import 'dart:core' as $core;

import 'package:fixnum/fixnum.dart' as $fixnum;
import 'package:protobuf/protobuf.dart' as $pb;

export 'package:protobuf/protobuf.dart' show GeneratedMessageGenericExtensions;

enum FuseMessage_Payload { request, response, notSet }

class FuseMessage extends $pb.GeneratedMessage {
  factory FuseMessage({
    $fixnum.Int64? id,
    $fixnum.Int64? fh,
    FuseRequest? request,
    FuseResponse? response,
  }) {
    final result = create();
    if (id != null) result.id = id;
    if (fh != null) result.fh = fh;
    if (request != null) result.request = request;
    if (response != null) result.response = response;
    return result;
  }

  FuseMessage._();

  factory FuseMessage.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory FuseMessage.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static const $core.Map<$core.int, FuseMessage_Payload>
      _FuseMessage_PayloadByTag = {
    3: FuseMessage_Payload.request,
    4: FuseMessage_Payload.response,
    0: FuseMessage_Payload.notSet
  };
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'FuseMessage',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'bentos.fuse'),
      createEmptyInstance: create)
    ..oo(0, [3, 4])
    ..a<$fixnum.Int64>(1, _omitFieldNames ? '' : 'id', $pb.PbFieldType.OU6,
        defaultOrMaker: $fixnum.Int64.ZERO)
    ..a<$fixnum.Int64>(2, _omitFieldNames ? '' : 'fh', $pb.PbFieldType.OU6,
        defaultOrMaker: $fixnum.Int64.ZERO)
    ..aOM<FuseRequest>(3, _omitFieldNames ? '' : 'request',
        subBuilder: FuseRequest.create)
    ..aOM<FuseResponse>(4, _omitFieldNames ? '' : 'response',
        subBuilder: FuseResponse.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  FuseMessage clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  FuseMessage copyWith(void Function(FuseMessage) updates) =>
      super.copyWith((message) => updates(message as FuseMessage))
          as FuseMessage;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static FuseMessage create() => FuseMessage._();
  @$core.override
  FuseMessage createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static FuseMessage getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<FuseMessage>(create);
  static FuseMessage? _defaultInstance;

  @$pb.TagNumber(3)
  @$pb.TagNumber(4)
  FuseMessage_Payload whichPayload() =>
      _FuseMessage_PayloadByTag[$_whichOneof(0)]!;
  @$pb.TagNumber(3)
  @$pb.TagNumber(4)
  void clearPayload() => $_clearField($_whichOneof(0));

  /// Matches the request that triggered this response. Assigned by the fuse
  /// channel when serializing a callback. The driver echoes it back.
  @$pb.TagNumber(1)
  $fixnum.Int64 get id => $_getI64(0);
  @$pb.TagNumber(1)
  set id($fixnum.Int64 value) => $_setInt64(0, value);
  @$pb.TagNumber(1)
  $core.bool hasId() => $_has(0);
  @$pb.TagNumber(1)
  void clearId() => $_clearField(1);

  /// File handle — multiplexes VFS sessions over the single connection.
  /// Present on all ops except lifecycle ops (init/destroy) and inode-only
  /// ops (lookup, forget, getattr without fi, statfs, access).
  @$pb.TagNumber(2)
  $fixnum.Int64 get fh => $_getI64(1);
  @$pb.TagNumber(2)
  set fh($fixnum.Int64 value) => $_setInt64(1, value);
  @$pb.TagNumber(2)
  $core.bool hasFh() => $_has(1);
  @$pb.TagNumber(2)
  void clearFh() => $_clearField(2);

  @$pb.TagNumber(3)
  FuseRequest get request => $_getN(2);
  @$pb.TagNumber(3)
  set request(FuseRequest value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasRequest() => $_has(2);
  @$pb.TagNumber(3)
  void clearRequest() => $_clearField(3);
  @$pb.TagNumber(3)
  FuseRequest ensureRequest() => $_ensure(2);

  @$pb.TagNumber(4)
  FuseResponse get response => $_getN(3);
  @$pb.TagNumber(4)
  set response(FuseResponse value) => $_setField(4, value);
  @$pb.TagNumber(4)
  $core.bool hasResponse() => $_has(3);
  @$pb.TagNumber(4)
  void clearResponse() => $_clearField(4);
  @$pb.TagNumber(4)
  FuseResponse ensureResponse() => $_ensure(3);
}

enum FuseRequest_Op {
  open,
  read,
  write,
  flush,
  release,
  fsync,
  ioctl,
  poll,
  lookup,
  forget,
  getattr,
  setattr,
  readlink,
  mknod,
  mkdir,
  unlink,
  rmdir,
  symlink,
  rename,
  link,
  opendir,
  readdir,
  releasedir,
  fsyncdir,
  statfs,
  setxattr,
  getxattr,
  listxattr,
  removexattr,
  access,
  create_38,
  getlk,
  setlk,
  bmap,
  fallocate,
  readdirplus,
  copyFileRange,
  lseek,
  notSet
}

class FuseRequest extends $pb.GeneratedMessage {
  factory FuseRequest({
    OpenReq? open,
    ReadReq? read,
    WriteReq? write,
    FlushReq? flush,
    ReleaseReq? release,
    FsyncReq? fsync,
    IoctlReq? ioctl,
    PollReq? poll,
    LookupReq? lookup,
    ForgetReq? forget,
    GetattrReq? getattr,
    SetattrReq? setattr,
    ReadlinkReq? readlink,
    MknodReq? mknod,
    MkdirReq? mkdir,
    UnlinkReq? unlink,
    RmdirReq? rmdir,
    SymlinkReq? symlink,
    RenameReq? rename,
    LinkReq? link,
    OpendirReq? opendir,
    ReaddirReq? readdir,
    ReleasedirReq? releasedir,
    FsyncdirReq? fsyncdir,
    StatfsReq? statfs,
    SetxattrReq? setxattr,
    GetxattrReq? getxattr,
    ListxattrReq? listxattr,
    RemovexattrReq? removexattr,
    AccessReq? access,
    CreateReq? create_38,
    GetlkReq? getlk,
    SetlkReq? setlk,
    BmapReq? bmap,
    FallocateReq? fallocate,
    ReaddirplusReq? readdirplus,
    CopyFileRangeReq? copyFileRange,
    LseekReq? lseek,
  }) {
    final result = create();
    if (open != null) result.open = open;
    if (read != null) result.read = read;
    if (write != null) result.write = write;
    if (flush != null) result.flush = flush;
    if (release != null) result.release = release;
    if (fsync != null) result.fsync = fsync;
    if (ioctl != null) result.ioctl = ioctl;
    if (poll != null) result.poll = poll;
    if (lookup != null) result.lookup = lookup;
    if (forget != null) result.forget = forget;
    if (getattr != null) result.getattr = getattr;
    if (setattr != null) result.setattr = setattr;
    if (readlink != null) result.readlink = readlink;
    if (mknod != null) result.mknod = mknod;
    if (mkdir != null) result.mkdir = mkdir;
    if (unlink != null) result.unlink = unlink;
    if (rmdir != null) result.rmdir = rmdir;
    if (symlink != null) result.symlink = symlink;
    if (rename != null) result.rename = rename;
    if (link != null) result.link = link;
    if (opendir != null) result.opendir = opendir;
    if (readdir != null) result.readdir = readdir;
    if (releasedir != null) result.releasedir = releasedir;
    if (fsyncdir != null) result.fsyncdir = fsyncdir;
    if (statfs != null) result.statfs = statfs;
    if (setxattr != null) result.setxattr = setxattr;
    if (getxattr != null) result.getxattr = getxattr;
    if (listxattr != null) result.listxattr = listxattr;
    if (removexattr != null) result.removexattr = removexattr;
    if (access != null) result.access = access;
    if (create_38 != null) result.create_38 = create_38;
    if (getlk != null) result.getlk = getlk;
    if (setlk != null) result.setlk = setlk;
    if (bmap != null) result.bmap = bmap;
    if (fallocate != null) result.fallocate = fallocate;
    if (readdirplus != null) result.readdirplus = readdirplus;
    if (copyFileRange != null) result.copyFileRange = copyFileRange;
    if (lseek != null) result.lseek = lseek;
    return result;
  }

  FuseRequest._();

  factory FuseRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory FuseRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static const $core.Map<$core.int, FuseRequest_Op> _FuseRequest_OpByTag = {
    1: FuseRequest_Op.open,
    2: FuseRequest_Op.read,
    3: FuseRequest_Op.write,
    4: FuseRequest_Op.flush,
    5: FuseRequest_Op.release,
    6: FuseRequest_Op.fsync,
    7: FuseRequest_Op.ioctl,
    8: FuseRequest_Op.poll,
    16: FuseRequest_Op.lookup,
    17: FuseRequest_Op.forget,
    18: FuseRequest_Op.getattr,
    19: FuseRequest_Op.setattr,
    20: FuseRequest_Op.readlink,
    21: FuseRequest_Op.mknod,
    22: FuseRequest_Op.mkdir,
    23: FuseRequest_Op.unlink,
    24: FuseRequest_Op.rmdir,
    25: FuseRequest_Op.symlink,
    26: FuseRequest_Op.rename,
    27: FuseRequest_Op.link,
    28: FuseRequest_Op.opendir,
    29: FuseRequest_Op.readdir,
    30: FuseRequest_Op.releasedir,
    31: FuseRequest_Op.fsyncdir,
    32: FuseRequest_Op.statfs,
    33: FuseRequest_Op.setxattr,
    34: FuseRequest_Op.getxattr,
    35: FuseRequest_Op.listxattr,
    36: FuseRequest_Op.removexattr,
    37: FuseRequest_Op.access,
    38: FuseRequest_Op.create_38,
    39: FuseRequest_Op.getlk,
    40: FuseRequest_Op.setlk,
    41: FuseRequest_Op.bmap,
    42: FuseRequest_Op.fallocate,
    43: FuseRequest_Op.readdirplus,
    44: FuseRequest_Op.copyFileRange,
    45: FuseRequest_Op.lseek,
    0: FuseRequest_Op.notSet
  };
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'FuseRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'bentos.fuse'),
      createEmptyInstance: create)
    ..oo(0, [
      1,
      2,
      3,
      4,
      5,
      6,
      7,
      8,
      16,
      17,
      18,
      19,
      20,
      21,
      22,
      23,
      24,
      25,
      26,
      27,
      28,
      29,
      30,
      31,
      32,
      33,
      34,
      35,
      36,
      37,
      38,
      39,
      40,
      41,
      42,
      43,
      44,
      45
    ])
    ..aOM<OpenReq>(1, _omitFieldNames ? '' : 'open', subBuilder: OpenReq.create)
    ..aOM<ReadReq>(2, _omitFieldNames ? '' : 'read', subBuilder: ReadReq.create)
    ..aOM<WriteReq>(3, _omitFieldNames ? '' : 'write',
        subBuilder: WriteReq.create)
    ..aOM<FlushReq>(4, _omitFieldNames ? '' : 'flush',
        subBuilder: FlushReq.create)
    ..aOM<ReleaseReq>(5, _omitFieldNames ? '' : 'release',
        subBuilder: ReleaseReq.create)
    ..aOM<FsyncReq>(6, _omitFieldNames ? '' : 'fsync',
        subBuilder: FsyncReq.create)
    ..aOM<IoctlReq>(7, _omitFieldNames ? '' : 'ioctl',
        subBuilder: IoctlReq.create)
    ..aOM<PollReq>(8, _omitFieldNames ? '' : 'poll', subBuilder: PollReq.create)
    ..aOM<LookupReq>(16, _omitFieldNames ? '' : 'lookup',
        subBuilder: LookupReq.create)
    ..aOM<ForgetReq>(17, _omitFieldNames ? '' : 'forget',
        subBuilder: ForgetReq.create)
    ..aOM<GetattrReq>(18, _omitFieldNames ? '' : 'getattr',
        subBuilder: GetattrReq.create)
    ..aOM<SetattrReq>(19, _omitFieldNames ? '' : 'setattr',
        subBuilder: SetattrReq.create)
    ..aOM<ReadlinkReq>(20, _omitFieldNames ? '' : 'readlink',
        subBuilder: ReadlinkReq.create)
    ..aOM<MknodReq>(21, _omitFieldNames ? '' : 'mknod',
        subBuilder: MknodReq.create)
    ..aOM<MkdirReq>(22, _omitFieldNames ? '' : 'mkdir',
        subBuilder: MkdirReq.create)
    ..aOM<UnlinkReq>(23, _omitFieldNames ? '' : 'unlink',
        subBuilder: UnlinkReq.create)
    ..aOM<RmdirReq>(24, _omitFieldNames ? '' : 'rmdir',
        subBuilder: RmdirReq.create)
    ..aOM<SymlinkReq>(25, _omitFieldNames ? '' : 'symlink',
        subBuilder: SymlinkReq.create)
    ..aOM<RenameReq>(26, _omitFieldNames ? '' : 'rename',
        subBuilder: RenameReq.create)
    ..aOM<LinkReq>(27, _omitFieldNames ? '' : 'link',
        subBuilder: LinkReq.create)
    ..aOM<OpendirReq>(28, _omitFieldNames ? '' : 'opendir',
        subBuilder: OpendirReq.create)
    ..aOM<ReaddirReq>(29, _omitFieldNames ? '' : 'readdir',
        subBuilder: ReaddirReq.create)
    ..aOM<ReleasedirReq>(30, _omitFieldNames ? '' : 'releasedir',
        subBuilder: ReleasedirReq.create)
    ..aOM<FsyncdirReq>(31, _omitFieldNames ? '' : 'fsyncdir',
        subBuilder: FsyncdirReq.create)
    ..aOM<StatfsReq>(32, _omitFieldNames ? '' : 'statfs',
        subBuilder: StatfsReq.create)
    ..aOM<SetxattrReq>(33, _omitFieldNames ? '' : 'setxattr',
        subBuilder: SetxattrReq.create)
    ..aOM<GetxattrReq>(34, _omitFieldNames ? '' : 'getxattr',
        subBuilder: GetxattrReq.create)
    ..aOM<ListxattrReq>(35, _omitFieldNames ? '' : 'listxattr',
        subBuilder: ListxattrReq.create)
    ..aOM<RemovexattrReq>(36, _omitFieldNames ? '' : 'removexattr',
        subBuilder: RemovexattrReq.create)
    ..aOM<AccessReq>(37, _omitFieldNames ? '' : 'access',
        subBuilder: AccessReq.create)
    ..aOM<CreateReq>(38, _omitFieldNames ? '' : 'create',
        subBuilder: CreateReq.create)
    ..aOM<GetlkReq>(39, _omitFieldNames ? '' : 'getlk',
        subBuilder: GetlkReq.create)
    ..aOM<SetlkReq>(40, _omitFieldNames ? '' : 'setlk',
        subBuilder: SetlkReq.create)
    ..aOM<BmapReq>(41, _omitFieldNames ? '' : 'bmap',
        subBuilder: BmapReq.create)
    ..aOM<FallocateReq>(42, _omitFieldNames ? '' : 'fallocate',
        subBuilder: FallocateReq.create)
    ..aOM<ReaddirplusReq>(43, _omitFieldNames ? '' : 'readdirplus',
        subBuilder: ReaddirplusReq.create)
    ..aOM<CopyFileRangeReq>(44, _omitFieldNames ? '' : 'copyFileRange',
        subBuilder: CopyFileRangeReq.create)
    ..aOM<LseekReq>(45, _omitFieldNames ? '' : 'lseek',
        subBuilder: LseekReq.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  FuseRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  FuseRequest copyWith(void Function(FuseRequest) updates) =>
      super.copyWith((message) => updates(message as FuseRequest))
          as FuseRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static FuseRequest create() => FuseRequest._();
  @$core.override
  FuseRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static FuseRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<FuseRequest>(create);
  static FuseRequest? _defaultInstance;

  @$pb.TagNumber(1)
  @$pb.TagNumber(2)
  @$pb.TagNumber(3)
  @$pb.TagNumber(4)
  @$pb.TagNumber(5)
  @$pb.TagNumber(6)
  @$pb.TagNumber(7)
  @$pb.TagNumber(8)
  @$pb.TagNumber(16)
  @$pb.TagNumber(17)
  @$pb.TagNumber(18)
  @$pb.TagNumber(19)
  @$pb.TagNumber(20)
  @$pb.TagNumber(21)
  @$pb.TagNumber(22)
  @$pb.TagNumber(23)
  @$pb.TagNumber(24)
  @$pb.TagNumber(25)
  @$pb.TagNumber(26)
  @$pb.TagNumber(27)
  @$pb.TagNumber(28)
  @$pb.TagNumber(29)
  @$pb.TagNumber(30)
  @$pb.TagNumber(31)
  @$pb.TagNumber(32)
  @$pb.TagNumber(33)
  @$pb.TagNumber(34)
  @$pb.TagNumber(35)
  @$pb.TagNumber(36)
  @$pb.TagNumber(37)
  @$pb.TagNumber(38)
  @$pb.TagNumber(39)
  @$pb.TagNumber(40)
  @$pb.TagNumber(41)
  @$pb.TagNumber(42)
  @$pb.TagNumber(43)
  @$pb.TagNumber(44)
  @$pb.TagNumber(45)
  FuseRequest_Op whichOp() => _FuseRequest_OpByTag[$_whichOneof(0)]!;
  @$pb.TagNumber(1)
  @$pb.TagNumber(2)
  @$pb.TagNumber(3)
  @$pb.TagNumber(4)
  @$pb.TagNumber(5)
  @$pb.TagNumber(6)
  @$pb.TagNumber(7)
  @$pb.TagNumber(8)
  @$pb.TagNumber(16)
  @$pb.TagNumber(17)
  @$pb.TagNumber(18)
  @$pb.TagNumber(19)
  @$pb.TagNumber(20)
  @$pb.TagNumber(21)
  @$pb.TagNumber(22)
  @$pb.TagNumber(23)
  @$pb.TagNumber(24)
  @$pb.TagNumber(25)
  @$pb.TagNumber(26)
  @$pb.TagNumber(27)
  @$pb.TagNumber(28)
  @$pb.TagNumber(29)
  @$pb.TagNumber(30)
  @$pb.TagNumber(31)
  @$pb.TagNumber(32)
  @$pb.TagNumber(33)
  @$pb.TagNumber(34)
  @$pb.TagNumber(35)
  @$pb.TagNumber(36)
  @$pb.TagNumber(37)
  @$pb.TagNumber(38)
  @$pb.TagNumber(39)
  @$pb.TagNumber(40)
  @$pb.TagNumber(41)
  @$pb.TagNumber(42)
  @$pb.TagNumber(43)
  @$pb.TagNumber(44)
  @$pb.TagNumber(45)
  void clearOp() => $_clearField($_whichOneof(0));

  /// — CUSE + FUSE common (file ops) —
  @$pb.TagNumber(1)
  OpenReq get open => $_getN(0);
  @$pb.TagNumber(1)
  set open(OpenReq value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasOpen() => $_has(0);
  @$pb.TagNumber(1)
  void clearOpen() => $_clearField(1);
  @$pb.TagNumber(1)
  OpenReq ensureOpen() => $_ensure(0);

  @$pb.TagNumber(2)
  ReadReq get read => $_getN(1);
  @$pb.TagNumber(2)
  set read(ReadReq value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasRead() => $_has(1);
  @$pb.TagNumber(2)
  void clearRead() => $_clearField(2);
  @$pb.TagNumber(2)
  ReadReq ensureRead() => $_ensure(1);

  @$pb.TagNumber(3)
  WriteReq get write => $_getN(2);
  @$pb.TagNumber(3)
  set write(WriteReq value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasWrite() => $_has(2);
  @$pb.TagNumber(3)
  void clearWrite() => $_clearField(3);
  @$pb.TagNumber(3)
  WriteReq ensureWrite() => $_ensure(2);

  @$pb.TagNumber(4)
  FlushReq get flush => $_getN(3);
  @$pb.TagNumber(4)
  set flush(FlushReq value) => $_setField(4, value);
  @$pb.TagNumber(4)
  $core.bool hasFlush() => $_has(3);
  @$pb.TagNumber(4)
  void clearFlush() => $_clearField(4);
  @$pb.TagNumber(4)
  FlushReq ensureFlush() => $_ensure(3);

  @$pb.TagNumber(5)
  ReleaseReq get release => $_getN(4);
  @$pb.TagNumber(5)
  set release(ReleaseReq value) => $_setField(5, value);
  @$pb.TagNumber(5)
  $core.bool hasRelease() => $_has(4);
  @$pb.TagNumber(5)
  void clearRelease() => $_clearField(5);
  @$pb.TagNumber(5)
  ReleaseReq ensureRelease() => $_ensure(4);

  @$pb.TagNumber(6)
  FsyncReq get fsync => $_getN(5);
  @$pb.TagNumber(6)
  set fsync(FsyncReq value) => $_setField(6, value);
  @$pb.TagNumber(6)
  $core.bool hasFsync() => $_has(5);
  @$pb.TagNumber(6)
  void clearFsync() => $_clearField(6);
  @$pb.TagNumber(6)
  FsyncReq ensureFsync() => $_ensure(5);

  @$pb.TagNumber(7)
  IoctlReq get ioctl => $_getN(6);
  @$pb.TagNumber(7)
  set ioctl(IoctlReq value) => $_setField(7, value);
  @$pb.TagNumber(7)
  $core.bool hasIoctl() => $_has(6);
  @$pb.TagNumber(7)
  void clearIoctl() => $_clearField(7);
  @$pb.TagNumber(7)
  IoctlReq ensureIoctl() => $_ensure(6);

  @$pb.TagNumber(8)
  PollReq get poll => $_getN(7);
  @$pb.TagNumber(8)
  set poll(PollReq value) => $_setField(8, value);
  @$pb.TagNumber(8)
  $core.bool hasPoll() => $_has(7);
  @$pb.TagNumber(8)
  void clearPoll() => $_clearField(8);
  @$pb.TagNumber(8)
  PollReq ensurePoll() => $_ensure(7);

  /// — FUSE only (inode + directory ops) —
  @$pb.TagNumber(16)
  LookupReq get lookup => $_getN(8);
  @$pb.TagNumber(16)
  set lookup(LookupReq value) => $_setField(16, value);
  @$pb.TagNumber(16)
  $core.bool hasLookup() => $_has(8);
  @$pb.TagNumber(16)
  void clearLookup() => $_clearField(16);
  @$pb.TagNumber(16)
  LookupReq ensureLookup() => $_ensure(8);

  @$pb.TagNumber(17)
  ForgetReq get forget => $_getN(9);
  @$pb.TagNumber(17)
  set forget(ForgetReq value) => $_setField(17, value);
  @$pb.TagNumber(17)
  $core.bool hasForget() => $_has(9);
  @$pb.TagNumber(17)
  void clearForget() => $_clearField(17);
  @$pb.TagNumber(17)
  ForgetReq ensureForget() => $_ensure(9);

  @$pb.TagNumber(18)
  GetattrReq get getattr => $_getN(10);
  @$pb.TagNumber(18)
  set getattr(GetattrReq value) => $_setField(18, value);
  @$pb.TagNumber(18)
  $core.bool hasGetattr() => $_has(10);
  @$pb.TagNumber(18)
  void clearGetattr() => $_clearField(18);
  @$pb.TagNumber(18)
  GetattrReq ensureGetattr() => $_ensure(10);

  @$pb.TagNumber(19)
  SetattrReq get setattr => $_getN(11);
  @$pb.TagNumber(19)
  set setattr(SetattrReq value) => $_setField(19, value);
  @$pb.TagNumber(19)
  $core.bool hasSetattr() => $_has(11);
  @$pb.TagNumber(19)
  void clearSetattr() => $_clearField(19);
  @$pb.TagNumber(19)
  SetattrReq ensureSetattr() => $_ensure(11);

  @$pb.TagNumber(20)
  ReadlinkReq get readlink => $_getN(12);
  @$pb.TagNumber(20)
  set readlink(ReadlinkReq value) => $_setField(20, value);
  @$pb.TagNumber(20)
  $core.bool hasReadlink() => $_has(12);
  @$pb.TagNumber(20)
  void clearReadlink() => $_clearField(20);
  @$pb.TagNumber(20)
  ReadlinkReq ensureReadlink() => $_ensure(12);

  @$pb.TagNumber(21)
  MknodReq get mknod => $_getN(13);
  @$pb.TagNumber(21)
  set mknod(MknodReq value) => $_setField(21, value);
  @$pb.TagNumber(21)
  $core.bool hasMknod() => $_has(13);
  @$pb.TagNumber(21)
  void clearMknod() => $_clearField(21);
  @$pb.TagNumber(21)
  MknodReq ensureMknod() => $_ensure(13);

  @$pb.TagNumber(22)
  MkdirReq get mkdir => $_getN(14);
  @$pb.TagNumber(22)
  set mkdir(MkdirReq value) => $_setField(22, value);
  @$pb.TagNumber(22)
  $core.bool hasMkdir() => $_has(14);
  @$pb.TagNumber(22)
  void clearMkdir() => $_clearField(22);
  @$pb.TagNumber(22)
  MkdirReq ensureMkdir() => $_ensure(14);

  @$pb.TagNumber(23)
  UnlinkReq get unlink => $_getN(15);
  @$pb.TagNumber(23)
  set unlink(UnlinkReq value) => $_setField(23, value);
  @$pb.TagNumber(23)
  $core.bool hasUnlink() => $_has(15);
  @$pb.TagNumber(23)
  void clearUnlink() => $_clearField(23);
  @$pb.TagNumber(23)
  UnlinkReq ensureUnlink() => $_ensure(15);

  @$pb.TagNumber(24)
  RmdirReq get rmdir => $_getN(16);
  @$pb.TagNumber(24)
  set rmdir(RmdirReq value) => $_setField(24, value);
  @$pb.TagNumber(24)
  $core.bool hasRmdir() => $_has(16);
  @$pb.TagNumber(24)
  void clearRmdir() => $_clearField(24);
  @$pb.TagNumber(24)
  RmdirReq ensureRmdir() => $_ensure(16);

  @$pb.TagNumber(25)
  SymlinkReq get symlink => $_getN(17);
  @$pb.TagNumber(25)
  set symlink(SymlinkReq value) => $_setField(25, value);
  @$pb.TagNumber(25)
  $core.bool hasSymlink() => $_has(17);
  @$pb.TagNumber(25)
  void clearSymlink() => $_clearField(25);
  @$pb.TagNumber(25)
  SymlinkReq ensureSymlink() => $_ensure(17);

  @$pb.TagNumber(26)
  RenameReq get rename => $_getN(18);
  @$pb.TagNumber(26)
  set rename(RenameReq value) => $_setField(26, value);
  @$pb.TagNumber(26)
  $core.bool hasRename() => $_has(18);
  @$pb.TagNumber(26)
  void clearRename() => $_clearField(26);
  @$pb.TagNumber(26)
  RenameReq ensureRename() => $_ensure(18);

  @$pb.TagNumber(27)
  LinkReq get link => $_getN(19);
  @$pb.TagNumber(27)
  set link(LinkReq value) => $_setField(27, value);
  @$pb.TagNumber(27)
  $core.bool hasLink() => $_has(19);
  @$pb.TagNumber(27)
  void clearLink() => $_clearField(27);
  @$pb.TagNumber(27)
  LinkReq ensureLink() => $_ensure(19);

  @$pb.TagNumber(28)
  OpendirReq get opendir => $_getN(20);
  @$pb.TagNumber(28)
  set opendir(OpendirReq value) => $_setField(28, value);
  @$pb.TagNumber(28)
  $core.bool hasOpendir() => $_has(20);
  @$pb.TagNumber(28)
  void clearOpendir() => $_clearField(28);
  @$pb.TagNumber(28)
  OpendirReq ensureOpendir() => $_ensure(20);

  @$pb.TagNumber(29)
  ReaddirReq get readdir => $_getN(21);
  @$pb.TagNumber(29)
  set readdir(ReaddirReq value) => $_setField(29, value);
  @$pb.TagNumber(29)
  $core.bool hasReaddir() => $_has(21);
  @$pb.TagNumber(29)
  void clearReaddir() => $_clearField(29);
  @$pb.TagNumber(29)
  ReaddirReq ensureReaddir() => $_ensure(21);

  @$pb.TagNumber(30)
  ReleasedirReq get releasedir => $_getN(22);
  @$pb.TagNumber(30)
  set releasedir(ReleasedirReq value) => $_setField(30, value);
  @$pb.TagNumber(30)
  $core.bool hasReleasedir() => $_has(22);
  @$pb.TagNumber(30)
  void clearReleasedir() => $_clearField(30);
  @$pb.TagNumber(30)
  ReleasedirReq ensureReleasedir() => $_ensure(22);

  @$pb.TagNumber(31)
  FsyncdirReq get fsyncdir => $_getN(23);
  @$pb.TagNumber(31)
  set fsyncdir(FsyncdirReq value) => $_setField(31, value);
  @$pb.TagNumber(31)
  $core.bool hasFsyncdir() => $_has(23);
  @$pb.TagNumber(31)
  void clearFsyncdir() => $_clearField(31);
  @$pb.TagNumber(31)
  FsyncdirReq ensureFsyncdir() => $_ensure(23);

  @$pb.TagNumber(32)
  StatfsReq get statfs => $_getN(24);
  @$pb.TagNumber(32)
  set statfs(StatfsReq value) => $_setField(32, value);
  @$pb.TagNumber(32)
  $core.bool hasStatfs() => $_has(24);
  @$pb.TagNumber(32)
  void clearStatfs() => $_clearField(32);
  @$pb.TagNumber(32)
  StatfsReq ensureStatfs() => $_ensure(24);

  @$pb.TagNumber(33)
  SetxattrReq get setxattr => $_getN(25);
  @$pb.TagNumber(33)
  set setxattr(SetxattrReq value) => $_setField(33, value);
  @$pb.TagNumber(33)
  $core.bool hasSetxattr() => $_has(25);
  @$pb.TagNumber(33)
  void clearSetxattr() => $_clearField(33);
  @$pb.TagNumber(33)
  SetxattrReq ensureSetxattr() => $_ensure(25);

  @$pb.TagNumber(34)
  GetxattrReq get getxattr => $_getN(26);
  @$pb.TagNumber(34)
  set getxattr(GetxattrReq value) => $_setField(34, value);
  @$pb.TagNumber(34)
  $core.bool hasGetxattr() => $_has(26);
  @$pb.TagNumber(34)
  void clearGetxattr() => $_clearField(34);
  @$pb.TagNumber(34)
  GetxattrReq ensureGetxattr() => $_ensure(26);

  @$pb.TagNumber(35)
  ListxattrReq get listxattr => $_getN(27);
  @$pb.TagNumber(35)
  set listxattr(ListxattrReq value) => $_setField(35, value);
  @$pb.TagNumber(35)
  $core.bool hasListxattr() => $_has(27);
  @$pb.TagNumber(35)
  void clearListxattr() => $_clearField(35);
  @$pb.TagNumber(35)
  ListxattrReq ensureListxattr() => $_ensure(27);

  @$pb.TagNumber(36)
  RemovexattrReq get removexattr => $_getN(28);
  @$pb.TagNumber(36)
  set removexattr(RemovexattrReq value) => $_setField(36, value);
  @$pb.TagNumber(36)
  $core.bool hasRemovexattr() => $_has(28);
  @$pb.TagNumber(36)
  void clearRemovexattr() => $_clearField(36);
  @$pb.TagNumber(36)
  RemovexattrReq ensureRemovexattr() => $_ensure(28);

  @$pb.TagNumber(37)
  AccessReq get access => $_getN(29);
  @$pb.TagNumber(37)
  set access(AccessReq value) => $_setField(37, value);
  @$pb.TagNumber(37)
  $core.bool hasAccess() => $_has(29);
  @$pb.TagNumber(37)
  void clearAccess() => $_clearField(37);
  @$pb.TagNumber(37)
  AccessReq ensureAccess() => $_ensure(29);

  @$pb.TagNumber(38)
  CreateReq get create_38 => $_getN(30);
  @$pb.TagNumber(38)
  set create_38(CreateReq value) => $_setField(38, value);
  @$pb.TagNumber(38)
  $core.bool hasCreate_38() => $_has(30);
  @$pb.TagNumber(38)
  void clearCreate_38() => $_clearField(38);
  @$pb.TagNumber(38)
  CreateReq ensureCreate_38() => $_ensure(30);

  @$pb.TagNumber(39)
  GetlkReq get getlk => $_getN(31);
  @$pb.TagNumber(39)
  set getlk(GetlkReq value) => $_setField(39, value);
  @$pb.TagNumber(39)
  $core.bool hasGetlk() => $_has(31);
  @$pb.TagNumber(39)
  void clearGetlk() => $_clearField(39);
  @$pb.TagNumber(39)
  GetlkReq ensureGetlk() => $_ensure(31);

  @$pb.TagNumber(40)
  SetlkReq get setlk => $_getN(32);
  @$pb.TagNumber(40)
  set setlk(SetlkReq value) => $_setField(40, value);
  @$pb.TagNumber(40)
  $core.bool hasSetlk() => $_has(32);
  @$pb.TagNumber(40)
  void clearSetlk() => $_clearField(40);
  @$pb.TagNumber(40)
  SetlkReq ensureSetlk() => $_ensure(32);

  @$pb.TagNumber(41)
  BmapReq get bmap => $_getN(33);
  @$pb.TagNumber(41)
  set bmap(BmapReq value) => $_setField(41, value);
  @$pb.TagNumber(41)
  $core.bool hasBmap() => $_has(33);
  @$pb.TagNumber(41)
  void clearBmap() => $_clearField(41);
  @$pb.TagNumber(41)
  BmapReq ensureBmap() => $_ensure(33);

  @$pb.TagNumber(42)
  FallocateReq get fallocate => $_getN(34);
  @$pb.TagNumber(42)
  set fallocate(FallocateReq value) => $_setField(42, value);
  @$pb.TagNumber(42)
  $core.bool hasFallocate() => $_has(34);
  @$pb.TagNumber(42)
  void clearFallocate() => $_clearField(42);
  @$pb.TagNumber(42)
  FallocateReq ensureFallocate() => $_ensure(34);

  @$pb.TagNumber(43)
  ReaddirplusReq get readdirplus => $_getN(35);
  @$pb.TagNumber(43)
  set readdirplus(ReaddirplusReq value) => $_setField(43, value);
  @$pb.TagNumber(43)
  $core.bool hasReaddirplus() => $_has(35);
  @$pb.TagNumber(43)
  void clearReaddirplus() => $_clearField(43);
  @$pb.TagNumber(43)
  ReaddirplusReq ensureReaddirplus() => $_ensure(35);

  @$pb.TagNumber(44)
  CopyFileRangeReq get copyFileRange => $_getN(36);
  @$pb.TagNumber(44)
  set copyFileRange(CopyFileRangeReq value) => $_setField(44, value);
  @$pb.TagNumber(44)
  $core.bool hasCopyFileRange() => $_has(36);
  @$pb.TagNumber(44)
  void clearCopyFileRange() => $_clearField(44);
  @$pb.TagNumber(44)
  CopyFileRangeReq ensureCopyFileRange() => $_ensure(36);

  @$pb.TagNumber(45)
  LseekReq get lseek => $_getN(37);
  @$pb.TagNumber(45)
  set lseek(LseekReq value) => $_setField(45, value);
  @$pb.TagNumber(45)
  $core.bool hasLseek() => $_has(37);
  @$pb.TagNumber(45)
  void clearLseek() => $_clearField(45);
  @$pb.TagNumber(45)
  LseekReq ensureLseek() => $_ensure(37);
}

class OpenReq extends $pb.GeneratedMessage {
  factory OpenReq({
    $core.int? flags,
  }) {
    final result = create();
    if (flags != null) result.flags = flags;
    return result;
  }

  OpenReq._();

  factory OpenReq.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory OpenReq.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'OpenReq',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'bentos.fuse'),
      createEmptyInstance: create)
    ..aI(1, _omitFieldNames ? '' : 'flags')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  OpenReq clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  OpenReq copyWith(void Function(OpenReq) updates) =>
      super.copyWith((message) => updates(message as OpenReq)) as OpenReq;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static OpenReq create() => OpenReq._();
  @$core.override
  OpenReq createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static OpenReq getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<OpenReq>(create);
  static OpenReq? _defaultInstance;

  @$pb.TagNumber(1)
  $core.int get flags => $_getIZ(0);
  @$pb.TagNumber(1)
  set flags($core.int value) => $_setSignedInt32(0, value);
  @$pb.TagNumber(1)
  $core.bool hasFlags() => $_has(0);
  @$pb.TagNumber(1)
  void clearFlags() => $_clearField(1);
}

class ReadReq extends $pb.GeneratedMessage {
  factory ReadReq({
    $fixnum.Int64? size,
    $fixnum.Int64? offset,
  }) {
    final result = create();
    if (size != null) result.size = size;
    if (offset != null) result.offset = offset;
    return result;
  }

  ReadReq._();

  factory ReadReq.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ReadReq.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ReadReq',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'bentos.fuse'),
      createEmptyInstance: create)
    ..a<$fixnum.Int64>(1, _omitFieldNames ? '' : 'size', $pb.PbFieldType.OU6,
        defaultOrMaker: $fixnum.Int64.ZERO)
    ..aInt64(2, _omitFieldNames ? '' : 'offset')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ReadReq clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ReadReq copyWith(void Function(ReadReq) updates) =>
      super.copyWith((message) => updates(message as ReadReq)) as ReadReq;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ReadReq create() => ReadReq._();
  @$core.override
  ReadReq createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ReadReq getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<ReadReq>(create);
  static ReadReq? _defaultInstance;

  @$pb.TagNumber(1)
  $fixnum.Int64 get size => $_getI64(0);
  @$pb.TagNumber(1)
  set size($fixnum.Int64 value) => $_setInt64(0, value);
  @$pb.TagNumber(1)
  $core.bool hasSize() => $_has(0);
  @$pb.TagNumber(1)
  void clearSize() => $_clearField(1);

  @$pb.TagNumber(2)
  $fixnum.Int64 get offset => $_getI64(1);
  @$pb.TagNumber(2)
  set offset($fixnum.Int64 value) => $_setInt64(1, value);
  @$pb.TagNumber(2)
  $core.bool hasOffset() => $_has(1);
  @$pb.TagNumber(2)
  void clearOffset() => $_clearField(2);
}

class WriteReq extends $pb.GeneratedMessage {
  factory WriteReq({
    $core.List<$core.int>? data,
    $fixnum.Int64? offset,
  }) {
    final result = create();
    if (data != null) result.data = data;
    if (offset != null) result.offset = offset;
    return result;
  }

  WriteReq._();

  factory WriteReq.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory WriteReq.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'WriteReq',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'bentos.fuse'),
      createEmptyInstance: create)
    ..a<$core.List<$core.int>>(
        1, _omitFieldNames ? '' : 'data', $pb.PbFieldType.OY)
    ..aInt64(2, _omitFieldNames ? '' : 'offset')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  WriteReq clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  WriteReq copyWith(void Function(WriteReq) updates) =>
      super.copyWith((message) => updates(message as WriteReq)) as WriteReq;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static WriteReq create() => WriteReq._();
  @$core.override
  WriteReq createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static WriteReq getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<WriteReq>(create);
  static WriteReq? _defaultInstance;

  @$pb.TagNumber(1)
  $core.List<$core.int> get data => $_getN(0);
  @$pb.TagNumber(1)
  set data($core.List<$core.int> value) => $_setBytes(0, value);
  @$pb.TagNumber(1)
  $core.bool hasData() => $_has(0);
  @$pb.TagNumber(1)
  void clearData() => $_clearField(1);

  @$pb.TagNumber(2)
  $fixnum.Int64 get offset => $_getI64(1);
  @$pb.TagNumber(2)
  set offset($fixnum.Int64 value) => $_setInt64(1, value);
  @$pb.TagNumber(2)
  $core.bool hasOffset() => $_has(1);
  @$pb.TagNumber(2)
  void clearOffset() => $_clearField(2);
}

class FlushReq extends $pb.GeneratedMessage {
  factory FlushReq({
    $fixnum.Int64? lockOwner,
  }) {
    final result = create();
    if (lockOwner != null) result.lockOwner = lockOwner;
    return result;
  }

  FlushReq._();

  factory FlushReq.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory FlushReq.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'FlushReq',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'bentos.fuse'),
      createEmptyInstance: create)
    ..a<$fixnum.Int64>(
        1, _omitFieldNames ? '' : 'lockOwner', $pb.PbFieldType.OU6,
        defaultOrMaker: $fixnum.Int64.ZERO)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  FlushReq clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  FlushReq copyWith(void Function(FlushReq) updates) =>
      super.copyWith((message) => updates(message as FlushReq)) as FlushReq;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static FlushReq create() => FlushReq._();
  @$core.override
  FlushReq createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static FlushReq getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<FlushReq>(create);
  static FlushReq? _defaultInstance;

  @$pb.TagNumber(1)
  $fixnum.Int64 get lockOwner => $_getI64(0);
  @$pb.TagNumber(1)
  set lockOwner($fixnum.Int64 value) => $_setInt64(0, value);
  @$pb.TagNumber(1)
  $core.bool hasLockOwner() => $_has(0);
  @$pb.TagNumber(1)
  void clearLockOwner() => $_clearField(1);
}

class ReleaseReq extends $pb.GeneratedMessage {
  factory ReleaseReq({
    $core.int? flags,
    $fixnum.Int64? lockOwner,
  }) {
    final result = create();
    if (flags != null) result.flags = flags;
    if (lockOwner != null) result.lockOwner = lockOwner;
    return result;
  }

  ReleaseReq._();

  factory ReleaseReq.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ReleaseReq.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ReleaseReq',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'bentos.fuse'),
      createEmptyInstance: create)
    ..aI(1, _omitFieldNames ? '' : 'flags')
    ..a<$fixnum.Int64>(
        2, _omitFieldNames ? '' : 'lockOwner', $pb.PbFieldType.OU6,
        defaultOrMaker: $fixnum.Int64.ZERO)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ReleaseReq clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ReleaseReq copyWith(void Function(ReleaseReq) updates) =>
      super.copyWith((message) => updates(message as ReleaseReq)) as ReleaseReq;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ReleaseReq create() => ReleaseReq._();
  @$core.override
  ReleaseReq createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ReleaseReq getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ReleaseReq>(create);
  static ReleaseReq? _defaultInstance;

  @$pb.TagNumber(1)
  $core.int get flags => $_getIZ(0);
  @$pb.TagNumber(1)
  set flags($core.int value) => $_setSignedInt32(0, value);
  @$pb.TagNumber(1)
  $core.bool hasFlags() => $_has(0);
  @$pb.TagNumber(1)
  void clearFlags() => $_clearField(1);

  @$pb.TagNumber(2)
  $fixnum.Int64 get lockOwner => $_getI64(1);
  @$pb.TagNumber(2)
  set lockOwner($fixnum.Int64 value) => $_setInt64(1, value);
  @$pb.TagNumber(2)
  $core.bool hasLockOwner() => $_has(1);
  @$pb.TagNumber(2)
  void clearLockOwner() => $_clearField(2);
}

class FsyncReq extends $pb.GeneratedMessage {
  factory FsyncReq({
    $core.bool? datasync,
  }) {
    final result = create();
    if (datasync != null) result.datasync = datasync;
    return result;
  }

  FsyncReq._();

  factory FsyncReq.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory FsyncReq.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'FsyncReq',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'bentos.fuse'),
      createEmptyInstance: create)
    ..aOB(1, _omitFieldNames ? '' : 'datasync')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  FsyncReq clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  FsyncReq copyWith(void Function(FsyncReq) updates) =>
      super.copyWith((message) => updates(message as FsyncReq)) as FsyncReq;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static FsyncReq create() => FsyncReq._();
  @$core.override
  FsyncReq createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static FsyncReq getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<FsyncReq>(create);
  static FsyncReq? _defaultInstance;

  @$pb.TagNumber(1)
  $core.bool get datasync => $_getBF(0);
  @$pb.TagNumber(1)
  set datasync($core.bool value) => $_setBool(0, value);
  @$pb.TagNumber(1)
  $core.bool hasDatasync() => $_has(0);
  @$pb.TagNumber(1)
  void clearDatasync() => $_clearField(1);
}

class IoctlReq extends $pb.GeneratedMessage {
  factory IoctlReq({
    $core.int? cmd,
    $core.int? flags,
    $core.List<$core.int>? inBuf,
    $fixnum.Int64? outBufsz,
  }) {
    final result = create();
    if (cmd != null) result.cmd = cmd;
    if (flags != null) result.flags = flags;
    if (inBuf != null) result.inBuf = inBuf;
    if (outBufsz != null) result.outBufsz = outBufsz;
    return result;
  }

  IoctlReq._();

  factory IoctlReq.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory IoctlReq.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'IoctlReq',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'bentos.fuse'),
      createEmptyInstance: create)
    ..aI(1, _omitFieldNames ? '' : 'cmd', fieldType: $pb.PbFieldType.OU3)
    ..aI(2, _omitFieldNames ? '' : 'flags', fieldType: $pb.PbFieldType.OU3)
    ..a<$core.List<$core.int>>(
        3, _omitFieldNames ? '' : 'inBuf', $pb.PbFieldType.OY)
    ..a<$fixnum.Int64>(
        4, _omitFieldNames ? '' : 'outBufsz', $pb.PbFieldType.OU6,
        defaultOrMaker: $fixnum.Int64.ZERO)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  IoctlReq clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  IoctlReq copyWith(void Function(IoctlReq) updates) =>
      super.copyWith((message) => updates(message as IoctlReq)) as IoctlReq;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static IoctlReq create() => IoctlReq._();
  @$core.override
  IoctlReq createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static IoctlReq getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<IoctlReq>(create);
  static IoctlReq? _defaultInstance;

  @$pb.TagNumber(1)
  $core.int get cmd => $_getIZ(0);
  @$pb.TagNumber(1)
  set cmd($core.int value) => $_setUnsignedInt32(0, value);
  @$pb.TagNumber(1)
  $core.bool hasCmd() => $_has(0);
  @$pb.TagNumber(1)
  void clearCmd() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.int get flags => $_getIZ(1);
  @$pb.TagNumber(2)
  set flags($core.int value) => $_setUnsignedInt32(1, value);
  @$pb.TagNumber(2)
  $core.bool hasFlags() => $_has(1);
  @$pb.TagNumber(2)
  void clearFlags() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.List<$core.int> get inBuf => $_getN(2);
  @$pb.TagNumber(3)
  set inBuf($core.List<$core.int> value) => $_setBytes(2, value);
  @$pb.TagNumber(3)
  $core.bool hasInBuf() => $_has(2);
  @$pb.TagNumber(3)
  void clearInBuf() => $_clearField(3);

  @$pb.TagNumber(4)
  $fixnum.Int64 get outBufsz => $_getI64(3);
  @$pb.TagNumber(4)
  set outBufsz($fixnum.Int64 value) => $_setInt64(3, value);
  @$pb.TagNumber(4)
  $core.bool hasOutBufsz() => $_has(3);
  @$pb.TagNumber(4)
  void clearOutBufsz() => $_clearField(4);
}

class PollReq extends $pb.GeneratedMessage {
  factory PollReq({
    $core.int? events,
    $fixnum.Int64? kh,
  }) {
    final result = create();
    if (events != null) result.events = events;
    if (kh != null) result.kh = kh;
    return result;
  }

  PollReq._();

  factory PollReq.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory PollReq.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'PollReq',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'bentos.fuse'),
      createEmptyInstance: create)
    ..aI(1, _omitFieldNames ? '' : 'events', fieldType: $pb.PbFieldType.OU3)
    ..a<$fixnum.Int64>(2, _omitFieldNames ? '' : 'kh', $pb.PbFieldType.OU6,
        defaultOrMaker: $fixnum.Int64.ZERO)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PollReq clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PollReq copyWith(void Function(PollReq) updates) =>
      super.copyWith((message) => updates(message as PollReq)) as PollReq;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static PollReq create() => PollReq._();
  @$core.override
  PollReq createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static PollReq getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<PollReq>(create);
  static PollReq? _defaultInstance;

  @$pb.TagNumber(1)
  $core.int get events => $_getIZ(0);
  @$pb.TagNumber(1)
  set events($core.int value) => $_setUnsignedInt32(0, value);
  @$pb.TagNumber(1)
  $core.bool hasEvents() => $_has(0);
  @$pb.TagNumber(1)
  void clearEvents() => $_clearField(1);

  @$pb.TagNumber(2)
  $fixnum.Int64 get kh => $_getI64(1);
  @$pb.TagNumber(2)
  set kh($fixnum.Int64 value) => $_setInt64(1, value);
  @$pb.TagNumber(2)
  $core.bool hasKh() => $_has(1);
  @$pb.TagNumber(2)
  void clearKh() => $_clearField(2);
}

class LookupReq extends $pb.GeneratedMessage {
  factory LookupReq({
    $fixnum.Int64? parent,
    $core.String? name,
  }) {
    final result = create();
    if (parent != null) result.parent = parent;
    if (name != null) result.name = name;
    return result;
  }

  LookupReq._();

  factory LookupReq.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory LookupReq.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'LookupReq',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'bentos.fuse'),
      createEmptyInstance: create)
    ..a<$fixnum.Int64>(1, _omitFieldNames ? '' : 'parent', $pb.PbFieldType.OU6,
        defaultOrMaker: $fixnum.Int64.ZERO)
    ..aOS(2, _omitFieldNames ? '' : 'name')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  LookupReq clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  LookupReq copyWith(void Function(LookupReq) updates) =>
      super.copyWith((message) => updates(message as LookupReq)) as LookupReq;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static LookupReq create() => LookupReq._();
  @$core.override
  LookupReq createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static LookupReq getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<LookupReq>(create);
  static LookupReq? _defaultInstance;

  @$pb.TagNumber(1)
  $fixnum.Int64 get parent => $_getI64(0);
  @$pb.TagNumber(1)
  set parent($fixnum.Int64 value) => $_setInt64(0, value);
  @$pb.TagNumber(1)
  $core.bool hasParent() => $_has(0);
  @$pb.TagNumber(1)
  void clearParent() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get name => $_getSZ(1);
  @$pb.TagNumber(2)
  set name($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasName() => $_has(1);
  @$pb.TagNumber(2)
  void clearName() => $_clearField(2);
}

class ForgetReq extends $pb.GeneratedMessage {
  factory ForgetReq({
    $fixnum.Int64? ino,
    $fixnum.Int64? nlookup,
  }) {
    final result = create();
    if (ino != null) result.ino = ino;
    if (nlookup != null) result.nlookup = nlookup;
    return result;
  }

  ForgetReq._();

  factory ForgetReq.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ForgetReq.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ForgetReq',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'bentos.fuse'),
      createEmptyInstance: create)
    ..a<$fixnum.Int64>(1, _omitFieldNames ? '' : 'ino', $pb.PbFieldType.OU6,
        defaultOrMaker: $fixnum.Int64.ZERO)
    ..a<$fixnum.Int64>(2, _omitFieldNames ? '' : 'nlookup', $pb.PbFieldType.OU6,
        defaultOrMaker: $fixnum.Int64.ZERO)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ForgetReq clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ForgetReq copyWith(void Function(ForgetReq) updates) =>
      super.copyWith((message) => updates(message as ForgetReq)) as ForgetReq;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ForgetReq create() => ForgetReq._();
  @$core.override
  ForgetReq createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ForgetReq getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<ForgetReq>(create);
  static ForgetReq? _defaultInstance;

  @$pb.TagNumber(1)
  $fixnum.Int64 get ino => $_getI64(0);
  @$pb.TagNumber(1)
  set ino($fixnum.Int64 value) => $_setInt64(0, value);
  @$pb.TagNumber(1)
  $core.bool hasIno() => $_has(0);
  @$pb.TagNumber(1)
  void clearIno() => $_clearField(1);

  @$pb.TagNumber(2)
  $fixnum.Int64 get nlookup => $_getI64(1);
  @$pb.TagNumber(2)
  set nlookup($fixnum.Int64 value) => $_setInt64(1, value);
  @$pb.TagNumber(2)
  $core.bool hasNlookup() => $_has(1);
  @$pb.TagNumber(2)
  void clearNlookup() => $_clearField(2);
}

class GetattrReq extends $pb.GeneratedMessage {
  factory GetattrReq({
    $fixnum.Int64? ino,
  }) {
    final result = create();
    if (ino != null) result.ino = ino;
    return result;
  }

  GetattrReq._();

  factory GetattrReq.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory GetattrReq.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetattrReq',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'bentos.fuse'),
      createEmptyInstance: create)
    ..a<$fixnum.Int64>(1, _omitFieldNames ? '' : 'ino', $pb.PbFieldType.OU6,
        defaultOrMaker: $fixnum.Int64.ZERO)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetattrReq clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetattrReq copyWith(void Function(GetattrReq) updates) =>
      super.copyWith((message) => updates(message as GetattrReq)) as GetattrReq;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GetattrReq create() => GetattrReq._();
  @$core.override
  GetattrReq createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static GetattrReq getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetattrReq>(create);
  static GetattrReq? _defaultInstance;

  @$pb.TagNumber(1)
  $fixnum.Int64 get ino => $_getI64(0);
  @$pb.TagNumber(1)
  set ino($fixnum.Int64 value) => $_setInt64(0, value);
  @$pb.TagNumber(1)
  $core.bool hasIno() => $_has(0);
  @$pb.TagNumber(1)
  void clearIno() => $_clearField(1);
}

class SetattrReq extends $pb.GeneratedMessage {
  factory SetattrReq({
    $fixnum.Int64? ino,
    StatAttr? attr,
    $core.int? toSet,
  }) {
    final result = create();
    if (ino != null) result.ino = ino;
    if (attr != null) result.attr = attr;
    if (toSet != null) result.toSet = toSet;
    return result;
  }

  SetattrReq._();

  factory SetattrReq.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory SetattrReq.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'SetattrReq',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'bentos.fuse'),
      createEmptyInstance: create)
    ..a<$fixnum.Int64>(1, _omitFieldNames ? '' : 'ino', $pb.PbFieldType.OU6,
        defaultOrMaker: $fixnum.Int64.ZERO)
    ..aOM<StatAttr>(2, _omitFieldNames ? '' : 'attr',
        subBuilder: StatAttr.create)
    ..aI(3, _omitFieldNames ? '' : 'toSet', fieldType: $pb.PbFieldType.OU3)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SetattrReq clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SetattrReq copyWith(void Function(SetattrReq) updates) =>
      super.copyWith((message) => updates(message as SetattrReq)) as SetattrReq;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static SetattrReq create() => SetattrReq._();
  @$core.override
  SetattrReq createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static SetattrReq getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<SetattrReq>(create);
  static SetattrReq? _defaultInstance;

  @$pb.TagNumber(1)
  $fixnum.Int64 get ino => $_getI64(0);
  @$pb.TagNumber(1)
  set ino($fixnum.Int64 value) => $_setInt64(0, value);
  @$pb.TagNumber(1)
  $core.bool hasIno() => $_has(0);
  @$pb.TagNumber(1)
  void clearIno() => $_clearField(1);

  @$pb.TagNumber(2)
  StatAttr get attr => $_getN(1);
  @$pb.TagNumber(2)
  set attr(StatAttr value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasAttr() => $_has(1);
  @$pb.TagNumber(2)
  void clearAttr() => $_clearField(2);
  @$pb.TagNumber(2)
  StatAttr ensureAttr() => $_ensure(1);

  @$pb.TagNumber(3)
  $core.int get toSet => $_getIZ(2);
  @$pb.TagNumber(3)
  set toSet($core.int value) => $_setUnsignedInt32(2, value);
  @$pb.TagNumber(3)
  $core.bool hasToSet() => $_has(2);
  @$pb.TagNumber(3)
  void clearToSet() => $_clearField(3);
}

class ReadlinkReq extends $pb.GeneratedMessage {
  factory ReadlinkReq({
    $fixnum.Int64? ino,
  }) {
    final result = create();
    if (ino != null) result.ino = ino;
    return result;
  }

  ReadlinkReq._();

  factory ReadlinkReq.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ReadlinkReq.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ReadlinkReq',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'bentos.fuse'),
      createEmptyInstance: create)
    ..a<$fixnum.Int64>(1, _omitFieldNames ? '' : 'ino', $pb.PbFieldType.OU6,
        defaultOrMaker: $fixnum.Int64.ZERO)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ReadlinkReq clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ReadlinkReq copyWith(void Function(ReadlinkReq) updates) =>
      super.copyWith((message) => updates(message as ReadlinkReq))
          as ReadlinkReq;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ReadlinkReq create() => ReadlinkReq._();
  @$core.override
  ReadlinkReq createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ReadlinkReq getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ReadlinkReq>(create);
  static ReadlinkReq? _defaultInstance;

  @$pb.TagNumber(1)
  $fixnum.Int64 get ino => $_getI64(0);
  @$pb.TagNumber(1)
  set ino($fixnum.Int64 value) => $_setInt64(0, value);
  @$pb.TagNumber(1)
  $core.bool hasIno() => $_has(0);
  @$pb.TagNumber(1)
  void clearIno() => $_clearField(1);
}

class MknodReq extends $pb.GeneratedMessage {
  factory MknodReq({
    $fixnum.Int64? parent,
    $core.String? name,
    $core.int? mode,
    $fixnum.Int64? rdev,
  }) {
    final result = create();
    if (parent != null) result.parent = parent;
    if (name != null) result.name = name;
    if (mode != null) result.mode = mode;
    if (rdev != null) result.rdev = rdev;
    return result;
  }

  MknodReq._();

  factory MknodReq.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory MknodReq.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'MknodReq',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'bentos.fuse'),
      createEmptyInstance: create)
    ..a<$fixnum.Int64>(1, _omitFieldNames ? '' : 'parent', $pb.PbFieldType.OU6,
        defaultOrMaker: $fixnum.Int64.ZERO)
    ..aOS(2, _omitFieldNames ? '' : 'name')
    ..aI(3, _omitFieldNames ? '' : 'mode', fieldType: $pb.PbFieldType.OU3)
    ..a<$fixnum.Int64>(4, _omitFieldNames ? '' : 'rdev', $pb.PbFieldType.OU6,
        defaultOrMaker: $fixnum.Int64.ZERO)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  MknodReq clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  MknodReq copyWith(void Function(MknodReq) updates) =>
      super.copyWith((message) => updates(message as MknodReq)) as MknodReq;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static MknodReq create() => MknodReq._();
  @$core.override
  MknodReq createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static MknodReq getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<MknodReq>(create);
  static MknodReq? _defaultInstance;

  @$pb.TagNumber(1)
  $fixnum.Int64 get parent => $_getI64(0);
  @$pb.TagNumber(1)
  set parent($fixnum.Int64 value) => $_setInt64(0, value);
  @$pb.TagNumber(1)
  $core.bool hasParent() => $_has(0);
  @$pb.TagNumber(1)
  void clearParent() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get name => $_getSZ(1);
  @$pb.TagNumber(2)
  set name($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasName() => $_has(1);
  @$pb.TagNumber(2)
  void clearName() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.int get mode => $_getIZ(2);
  @$pb.TagNumber(3)
  set mode($core.int value) => $_setUnsignedInt32(2, value);
  @$pb.TagNumber(3)
  $core.bool hasMode() => $_has(2);
  @$pb.TagNumber(3)
  void clearMode() => $_clearField(3);

  @$pb.TagNumber(4)
  $fixnum.Int64 get rdev => $_getI64(3);
  @$pb.TagNumber(4)
  set rdev($fixnum.Int64 value) => $_setInt64(3, value);
  @$pb.TagNumber(4)
  $core.bool hasRdev() => $_has(3);
  @$pb.TagNumber(4)
  void clearRdev() => $_clearField(4);
}

class MkdirReq extends $pb.GeneratedMessage {
  factory MkdirReq({
    $fixnum.Int64? parent,
    $core.String? name,
    $core.int? mode,
  }) {
    final result = create();
    if (parent != null) result.parent = parent;
    if (name != null) result.name = name;
    if (mode != null) result.mode = mode;
    return result;
  }

  MkdirReq._();

  factory MkdirReq.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory MkdirReq.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'MkdirReq',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'bentos.fuse'),
      createEmptyInstance: create)
    ..a<$fixnum.Int64>(1, _omitFieldNames ? '' : 'parent', $pb.PbFieldType.OU6,
        defaultOrMaker: $fixnum.Int64.ZERO)
    ..aOS(2, _omitFieldNames ? '' : 'name')
    ..aI(3, _omitFieldNames ? '' : 'mode', fieldType: $pb.PbFieldType.OU3)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  MkdirReq clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  MkdirReq copyWith(void Function(MkdirReq) updates) =>
      super.copyWith((message) => updates(message as MkdirReq)) as MkdirReq;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static MkdirReq create() => MkdirReq._();
  @$core.override
  MkdirReq createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static MkdirReq getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<MkdirReq>(create);
  static MkdirReq? _defaultInstance;

  @$pb.TagNumber(1)
  $fixnum.Int64 get parent => $_getI64(0);
  @$pb.TagNumber(1)
  set parent($fixnum.Int64 value) => $_setInt64(0, value);
  @$pb.TagNumber(1)
  $core.bool hasParent() => $_has(0);
  @$pb.TagNumber(1)
  void clearParent() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get name => $_getSZ(1);
  @$pb.TagNumber(2)
  set name($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasName() => $_has(1);
  @$pb.TagNumber(2)
  void clearName() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.int get mode => $_getIZ(2);
  @$pb.TagNumber(3)
  set mode($core.int value) => $_setUnsignedInt32(2, value);
  @$pb.TagNumber(3)
  $core.bool hasMode() => $_has(2);
  @$pb.TagNumber(3)
  void clearMode() => $_clearField(3);
}

class UnlinkReq extends $pb.GeneratedMessage {
  factory UnlinkReq({
    $fixnum.Int64? parent,
    $core.String? name,
  }) {
    final result = create();
    if (parent != null) result.parent = parent;
    if (name != null) result.name = name;
    return result;
  }

  UnlinkReq._();

  factory UnlinkReq.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory UnlinkReq.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'UnlinkReq',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'bentos.fuse'),
      createEmptyInstance: create)
    ..a<$fixnum.Int64>(1, _omitFieldNames ? '' : 'parent', $pb.PbFieldType.OU6,
        defaultOrMaker: $fixnum.Int64.ZERO)
    ..aOS(2, _omitFieldNames ? '' : 'name')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  UnlinkReq clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  UnlinkReq copyWith(void Function(UnlinkReq) updates) =>
      super.copyWith((message) => updates(message as UnlinkReq)) as UnlinkReq;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static UnlinkReq create() => UnlinkReq._();
  @$core.override
  UnlinkReq createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static UnlinkReq getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<UnlinkReq>(create);
  static UnlinkReq? _defaultInstance;

  @$pb.TagNumber(1)
  $fixnum.Int64 get parent => $_getI64(0);
  @$pb.TagNumber(1)
  set parent($fixnum.Int64 value) => $_setInt64(0, value);
  @$pb.TagNumber(1)
  $core.bool hasParent() => $_has(0);
  @$pb.TagNumber(1)
  void clearParent() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get name => $_getSZ(1);
  @$pb.TagNumber(2)
  set name($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasName() => $_has(1);
  @$pb.TagNumber(2)
  void clearName() => $_clearField(2);
}

class RmdirReq extends $pb.GeneratedMessage {
  factory RmdirReq({
    $fixnum.Int64? parent,
    $core.String? name,
  }) {
    final result = create();
    if (parent != null) result.parent = parent;
    if (name != null) result.name = name;
    return result;
  }

  RmdirReq._();

  factory RmdirReq.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory RmdirReq.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'RmdirReq',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'bentos.fuse'),
      createEmptyInstance: create)
    ..a<$fixnum.Int64>(1, _omitFieldNames ? '' : 'parent', $pb.PbFieldType.OU6,
        defaultOrMaker: $fixnum.Int64.ZERO)
    ..aOS(2, _omitFieldNames ? '' : 'name')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RmdirReq clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RmdirReq copyWith(void Function(RmdirReq) updates) =>
      super.copyWith((message) => updates(message as RmdirReq)) as RmdirReq;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static RmdirReq create() => RmdirReq._();
  @$core.override
  RmdirReq createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static RmdirReq getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<RmdirReq>(create);
  static RmdirReq? _defaultInstance;

  @$pb.TagNumber(1)
  $fixnum.Int64 get parent => $_getI64(0);
  @$pb.TagNumber(1)
  set parent($fixnum.Int64 value) => $_setInt64(0, value);
  @$pb.TagNumber(1)
  $core.bool hasParent() => $_has(0);
  @$pb.TagNumber(1)
  void clearParent() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get name => $_getSZ(1);
  @$pb.TagNumber(2)
  set name($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasName() => $_has(1);
  @$pb.TagNumber(2)
  void clearName() => $_clearField(2);
}

class SymlinkReq extends $pb.GeneratedMessage {
  factory SymlinkReq({
    $core.String? link,
    $fixnum.Int64? parent,
    $core.String? name,
  }) {
    final result = create();
    if (link != null) result.link = link;
    if (parent != null) result.parent = parent;
    if (name != null) result.name = name;
    return result;
  }

  SymlinkReq._();

  factory SymlinkReq.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory SymlinkReq.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'SymlinkReq',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'bentos.fuse'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'link')
    ..a<$fixnum.Int64>(2, _omitFieldNames ? '' : 'parent', $pb.PbFieldType.OU6,
        defaultOrMaker: $fixnum.Int64.ZERO)
    ..aOS(3, _omitFieldNames ? '' : 'name')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SymlinkReq clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SymlinkReq copyWith(void Function(SymlinkReq) updates) =>
      super.copyWith((message) => updates(message as SymlinkReq)) as SymlinkReq;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static SymlinkReq create() => SymlinkReq._();
  @$core.override
  SymlinkReq createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static SymlinkReq getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<SymlinkReq>(create);
  static SymlinkReq? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get link => $_getSZ(0);
  @$pb.TagNumber(1)
  set link($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasLink() => $_has(0);
  @$pb.TagNumber(1)
  void clearLink() => $_clearField(1);

  @$pb.TagNumber(2)
  $fixnum.Int64 get parent => $_getI64(1);
  @$pb.TagNumber(2)
  set parent($fixnum.Int64 value) => $_setInt64(1, value);
  @$pb.TagNumber(2)
  $core.bool hasParent() => $_has(1);
  @$pb.TagNumber(2)
  void clearParent() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get name => $_getSZ(2);
  @$pb.TagNumber(3)
  set name($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasName() => $_has(2);
  @$pb.TagNumber(3)
  void clearName() => $_clearField(3);
}

class RenameReq extends $pb.GeneratedMessage {
  factory RenameReq({
    $fixnum.Int64? parent,
    $core.String? name,
    $fixnum.Int64? newParent,
    $core.String? newName,
    $core.int? flags,
  }) {
    final result = create();
    if (parent != null) result.parent = parent;
    if (name != null) result.name = name;
    if (newParent != null) result.newParent = newParent;
    if (newName != null) result.newName = newName;
    if (flags != null) result.flags = flags;
    return result;
  }

  RenameReq._();

  factory RenameReq.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory RenameReq.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'RenameReq',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'bentos.fuse'),
      createEmptyInstance: create)
    ..a<$fixnum.Int64>(1, _omitFieldNames ? '' : 'parent', $pb.PbFieldType.OU6,
        defaultOrMaker: $fixnum.Int64.ZERO)
    ..aOS(2, _omitFieldNames ? '' : 'name')
    ..a<$fixnum.Int64>(
        3, _omitFieldNames ? '' : 'newParent', $pb.PbFieldType.OU6,
        defaultOrMaker: $fixnum.Int64.ZERO)
    ..aOS(4, _omitFieldNames ? '' : 'newName')
    ..aI(5, _omitFieldNames ? '' : 'flags', fieldType: $pb.PbFieldType.OU3)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RenameReq clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RenameReq copyWith(void Function(RenameReq) updates) =>
      super.copyWith((message) => updates(message as RenameReq)) as RenameReq;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static RenameReq create() => RenameReq._();
  @$core.override
  RenameReq createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static RenameReq getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<RenameReq>(create);
  static RenameReq? _defaultInstance;

  @$pb.TagNumber(1)
  $fixnum.Int64 get parent => $_getI64(0);
  @$pb.TagNumber(1)
  set parent($fixnum.Int64 value) => $_setInt64(0, value);
  @$pb.TagNumber(1)
  $core.bool hasParent() => $_has(0);
  @$pb.TagNumber(1)
  void clearParent() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get name => $_getSZ(1);
  @$pb.TagNumber(2)
  set name($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasName() => $_has(1);
  @$pb.TagNumber(2)
  void clearName() => $_clearField(2);

  @$pb.TagNumber(3)
  $fixnum.Int64 get newParent => $_getI64(2);
  @$pb.TagNumber(3)
  set newParent($fixnum.Int64 value) => $_setInt64(2, value);
  @$pb.TagNumber(3)
  $core.bool hasNewParent() => $_has(2);
  @$pb.TagNumber(3)
  void clearNewParent() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get newName => $_getSZ(3);
  @$pb.TagNumber(4)
  set newName($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasNewName() => $_has(3);
  @$pb.TagNumber(4)
  void clearNewName() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.int get flags => $_getIZ(4);
  @$pb.TagNumber(5)
  set flags($core.int value) => $_setUnsignedInt32(4, value);
  @$pb.TagNumber(5)
  $core.bool hasFlags() => $_has(4);
  @$pb.TagNumber(5)
  void clearFlags() => $_clearField(5);
}

class LinkReq extends $pb.GeneratedMessage {
  factory LinkReq({
    $fixnum.Int64? ino,
    $fixnum.Int64? newParent,
    $core.String? newName,
  }) {
    final result = create();
    if (ino != null) result.ino = ino;
    if (newParent != null) result.newParent = newParent;
    if (newName != null) result.newName = newName;
    return result;
  }

  LinkReq._();

  factory LinkReq.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory LinkReq.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'LinkReq',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'bentos.fuse'),
      createEmptyInstance: create)
    ..a<$fixnum.Int64>(1, _omitFieldNames ? '' : 'ino', $pb.PbFieldType.OU6,
        defaultOrMaker: $fixnum.Int64.ZERO)
    ..a<$fixnum.Int64>(
        2, _omitFieldNames ? '' : 'newParent', $pb.PbFieldType.OU6,
        defaultOrMaker: $fixnum.Int64.ZERO)
    ..aOS(3, _omitFieldNames ? '' : 'newName')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  LinkReq clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  LinkReq copyWith(void Function(LinkReq) updates) =>
      super.copyWith((message) => updates(message as LinkReq)) as LinkReq;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static LinkReq create() => LinkReq._();
  @$core.override
  LinkReq createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static LinkReq getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<LinkReq>(create);
  static LinkReq? _defaultInstance;

  @$pb.TagNumber(1)
  $fixnum.Int64 get ino => $_getI64(0);
  @$pb.TagNumber(1)
  set ino($fixnum.Int64 value) => $_setInt64(0, value);
  @$pb.TagNumber(1)
  $core.bool hasIno() => $_has(0);
  @$pb.TagNumber(1)
  void clearIno() => $_clearField(1);

  @$pb.TagNumber(2)
  $fixnum.Int64 get newParent => $_getI64(1);
  @$pb.TagNumber(2)
  set newParent($fixnum.Int64 value) => $_setInt64(1, value);
  @$pb.TagNumber(2)
  $core.bool hasNewParent() => $_has(1);
  @$pb.TagNumber(2)
  void clearNewParent() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get newName => $_getSZ(2);
  @$pb.TagNumber(3)
  set newName($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasNewName() => $_has(2);
  @$pb.TagNumber(3)
  void clearNewName() => $_clearField(3);
}

class OpendirReq extends $pb.GeneratedMessage {
  factory OpendirReq({
    $fixnum.Int64? ino,
    $core.int? flags,
  }) {
    final result = create();
    if (ino != null) result.ino = ino;
    if (flags != null) result.flags = flags;
    return result;
  }

  OpendirReq._();

  factory OpendirReq.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory OpendirReq.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'OpendirReq',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'bentos.fuse'),
      createEmptyInstance: create)
    ..a<$fixnum.Int64>(1, _omitFieldNames ? '' : 'ino', $pb.PbFieldType.OU6,
        defaultOrMaker: $fixnum.Int64.ZERO)
    ..aI(2, _omitFieldNames ? '' : 'flags')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  OpendirReq clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  OpendirReq copyWith(void Function(OpendirReq) updates) =>
      super.copyWith((message) => updates(message as OpendirReq)) as OpendirReq;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static OpendirReq create() => OpendirReq._();
  @$core.override
  OpendirReq createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static OpendirReq getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<OpendirReq>(create);
  static OpendirReq? _defaultInstance;

  @$pb.TagNumber(1)
  $fixnum.Int64 get ino => $_getI64(0);
  @$pb.TagNumber(1)
  set ino($fixnum.Int64 value) => $_setInt64(0, value);
  @$pb.TagNumber(1)
  $core.bool hasIno() => $_has(0);
  @$pb.TagNumber(1)
  void clearIno() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.int get flags => $_getIZ(1);
  @$pb.TagNumber(2)
  set flags($core.int value) => $_setSignedInt32(1, value);
  @$pb.TagNumber(2)
  $core.bool hasFlags() => $_has(1);
  @$pb.TagNumber(2)
  void clearFlags() => $_clearField(2);
}

class ReaddirReq extends $pb.GeneratedMessage {
  factory ReaddirReq({
    $fixnum.Int64? ino,
    $fixnum.Int64? size,
    $fixnum.Int64? offset,
  }) {
    final result = create();
    if (ino != null) result.ino = ino;
    if (size != null) result.size = size;
    if (offset != null) result.offset = offset;
    return result;
  }

  ReaddirReq._();

  factory ReaddirReq.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ReaddirReq.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ReaddirReq',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'bentos.fuse'),
      createEmptyInstance: create)
    ..a<$fixnum.Int64>(1, _omitFieldNames ? '' : 'ino', $pb.PbFieldType.OU6,
        defaultOrMaker: $fixnum.Int64.ZERO)
    ..a<$fixnum.Int64>(2, _omitFieldNames ? '' : 'size', $pb.PbFieldType.OU6,
        defaultOrMaker: $fixnum.Int64.ZERO)
    ..aInt64(3, _omitFieldNames ? '' : 'offset')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ReaddirReq clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ReaddirReq copyWith(void Function(ReaddirReq) updates) =>
      super.copyWith((message) => updates(message as ReaddirReq)) as ReaddirReq;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ReaddirReq create() => ReaddirReq._();
  @$core.override
  ReaddirReq createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ReaddirReq getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ReaddirReq>(create);
  static ReaddirReq? _defaultInstance;

  @$pb.TagNumber(1)
  $fixnum.Int64 get ino => $_getI64(0);
  @$pb.TagNumber(1)
  set ino($fixnum.Int64 value) => $_setInt64(0, value);
  @$pb.TagNumber(1)
  $core.bool hasIno() => $_has(0);
  @$pb.TagNumber(1)
  void clearIno() => $_clearField(1);

  @$pb.TagNumber(2)
  $fixnum.Int64 get size => $_getI64(1);
  @$pb.TagNumber(2)
  set size($fixnum.Int64 value) => $_setInt64(1, value);
  @$pb.TagNumber(2)
  $core.bool hasSize() => $_has(1);
  @$pb.TagNumber(2)
  void clearSize() => $_clearField(2);

  @$pb.TagNumber(3)
  $fixnum.Int64 get offset => $_getI64(2);
  @$pb.TagNumber(3)
  set offset($fixnum.Int64 value) => $_setInt64(2, value);
  @$pb.TagNumber(3)
  $core.bool hasOffset() => $_has(2);
  @$pb.TagNumber(3)
  void clearOffset() => $_clearField(3);
}

class ReleasedirReq extends $pb.GeneratedMessage {
  factory ReleasedirReq({
    $fixnum.Int64? ino,
  }) {
    final result = create();
    if (ino != null) result.ino = ino;
    return result;
  }

  ReleasedirReq._();

  factory ReleasedirReq.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ReleasedirReq.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ReleasedirReq',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'bentos.fuse'),
      createEmptyInstance: create)
    ..a<$fixnum.Int64>(1, _omitFieldNames ? '' : 'ino', $pb.PbFieldType.OU6,
        defaultOrMaker: $fixnum.Int64.ZERO)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ReleasedirReq clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ReleasedirReq copyWith(void Function(ReleasedirReq) updates) =>
      super.copyWith((message) => updates(message as ReleasedirReq))
          as ReleasedirReq;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ReleasedirReq create() => ReleasedirReq._();
  @$core.override
  ReleasedirReq createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ReleasedirReq getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ReleasedirReq>(create);
  static ReleasedirReq? _defaultInstance;

  @$pb.TagNumber(1)
  $fixnum.Int64 get ino => $_getI64(0);
  @$pb.TagNumber(1)
  set ino($fixnum.Int64 value) => $_setInt64(0, value);
  @$pb.TagNumber(1)
  $core.bool hasIno() => $_has(0);
  @$pb.TagNumber(1)
  void clearIno() => $_clearField(1);
}

class FsyncdirReq extends $pb.GeneratedMessage {
  factory FsyncdirReq({
    $fixnum.Int64? ino,
    $core.bool? datasync,
  }) {
    final result = create();
    if (ino != null) result.ino = ino;
    if (datasync != null) result.datasync = datasync;
    return result;
  }

  FsyncdirReq._();

  factory FsyncdirReq.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory FsyncdirReq.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'FsyncdirReq',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'bentos.fuse'),
      createEmptyInstance: create)
    ..a<$fixnum.Int64>(1, _omitFieldNames ? '' : 'ino', $pb.PbFieldType.OU6,
        defaultOrMaker: $fixnum.Int64.ZERO)
    ..aOB(2, _omitFieldNames ? '' : 'datasync')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  FsyncdirReq clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  FsyncdirReq copyWith(void Function(FsyncdirReq) updates) =>
      super.copyWith((message) => updates(message as FsyncdirReq))
          as FsyncdirReq;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static FsyncdirReq create() => FsyncdirReq._();
  @$core.override
  FsyncdirReq createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static FsyncdirReq getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<FsyncdirReq>(create);
  static FsyncdirReq? _defaultInstance;

  @$pb.TagNumber(1)
  $fixnum.Int64 get ino => $_getI64(0);
  @$pb.TagNumber(1)
  set ino($fixnum.Int64 value) => $_setInt64(0, value);
  @$pb.TagNumber(1)
  $core.bool hasIno() => $_has(0);
  @$pb.TagNumber(1)
  void clearIno() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.bool get datasync => $_getBF(1);
  @$pb.TagNumber(2)
  set datasync($core.bool value) => $_setBool(1, value);
  @$pb.TagNumber(2)
  $core.bool hasDatasync() => $_has(1);
  @$pb.TagNumber(2)
  void clearDatasync() => $_clearField(2);
}

class StatfsReq extends $pb.GeneratedMessage {
  factory StatfsReq({
    $fixnum.Int64? ino,
  }) {
    final result = create();
    if (ino != null) result.ino = ino;
    return result;
  }

  StatfsReq._();

  factory StatfsReq.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory StatfsReq.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'StatfsReq',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'bentos.fuse'),
      createEmptyInstance: create)
    ..a<$fixnum.Int64>(1, _omitFieldNames ? '' : 'ino', $pb.PbFieldType.OU6,
        defaultOrMaker: $fixnum.Int64.ZERO)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  StatfsReq clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  StatfsReq copyWith(void Function(StatfsReq) updates) =>
      super.copyWith((message) => updates(message as StatfsReq)) as StatfsReq;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static StatfsReq create() => StatfsReq._();
  @$core.override
  StatfsReq createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static StatfsReq getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<StatfsReq>(create);
  static StatfsReq? _defaultInstance;

  @$pb.TagNumber(1)
  $fixnum.Int64 get ino => $_getI64(0);
  @$pb.TagNumber(1)
  set ino($fixnum.Int64 value) => $_setInt64(0, value);
  @$pb.TagNumber(1)
  $core.bool hasIno() => $_has(0);
  @$pb.TagNumber(1)
  void clearIno() => $_clearField(1);
}

class SetxattrReq extends $pb.GeneratedMessage {
  factory SetxattrReq({
    $fixnum.Int64? ino,
    $core.String? name,
    $core.List<$core.int>? value,
    $core.int? flags,
  }) {
    final result = create();
    if (ino != null) result.ino = ino;
    if (name != null) result.name = name;
    if (value != null) result.value = value;
    if (flags != null) result.flags = flags;
    return result;
  }

  SetxattrReq._();

  factory SetxattrReq.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory SetxattrReq.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'SetxattrReq',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'bentos.fuse'),
      createEmptyInstance: create)
    ..a<$fixnum.Int64>(1, _omitFieldNames ? '' : 'ino', $pb.PbFieldType.OU6,
        defaultOrMaker: $fixnum.Int64.ZERO)
    ..aOS(2, _omitFieldNames ? '' : 'name')
    ..a<$core.List<$core.int>>(
        3, _omitFieldNames ? '' : 'value', $pb.PbFieldType.OY)
    ..aI(4, _omitFieldNames ? '' : 'flags', fieldType: $pb.PbFieldType.OU3)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SetxattrReq clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SetxattrReq copyWith(void Function(SetxattrReq) updates) =>
      super.copyWith((message) => updates(message as SetxattrReq))
          as SetxattrReq;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static SetxattrReq create() => SetxattrReq._();
  @$core.override
  SetxattrReq createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static SetxattrReq getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<SetxattrReq>(create);
  static SetxattrReq? _defaultInstance;

  @$pb.TagNumber(1)
  $fixnum.Int64 get ino => $_getI64(0);
  @$pb.TagNumber(1)
  set ino($fixnum.Int64 value) => $_setInt64(0, value);
  @$pb.TagNumber(1)
  $core.bool hasIno() => $_has(0);
  @$pb.TagNumber(1)
  void clearIno() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get name => $_getSZ(1);
  @$pb.TagNumber(2)
  set name($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasName() => $_has(1);
  @$pb.TagNumber(2)
  void clearName() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.List<$core.int> get value => $_getN(2);
  @$pb.TagNumber(3)
  set value($core.List<$core.int> value) => $_setBytes(2, value);
  @$pb.TagNumber(3)
  $core.bool hasValue() => $_has(2);
  @$pb.TagNumber(3)
  void clearValue() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.int get flags => $_getIZ(3);
  @$pb.TagNumber(4)
  set flags($core.int value) => $_setUnsignedInt32(3, value);
  @$pb.TagNumber(4)
  $core.bool hasFlags() => $_has(3);
  @$pb.TagNumber(4)
  void clearFlags() => $_clearField(4);
}

class GetxattrReq extends $pb.GeneratedMessage {
  factory GetxattrReq({
    $fixnum.Int64? ino,
    $core.String? name,
    $fixnum.Int64? size,
  }) {
    final result = create();
    if (ino != null) result.ino = ino;
    if (name != null) result.name = name;
    if (size != null) result.size = size;
    return result;
  }

  GetxattrReq._();

  factory GetxattrReq.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory GetxattrReq.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetxattrReq',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'bentos.fuse'),
      createEmptyInstance: create)
    ..a<$fixnum.Int64>(1, _omitFieldNames ? '' : 'ino', $pb.PbFieldType.OU6,
        defaultOrMaker: $fixnum.Int64.ZERO)
    ..aOS(2, _omitFieldNames ? '' : 'name')
    ..a<$fixnum.Int64>(3, _omitFieldNames ? '' : 'size', $pb.PbFieldType.OU6,
        defaultOrMaker: $fixnum.Int64.ZERO)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetxattrReq clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetxattrReq copyWith(void Function(GetxattrReq) updates) =>
      super.copyWith((message) => updates(message as GetxattrReq))
          as GetxattrReq;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GetxattrReq create() => GetxattrReq._();
  @$core.override
  GetxattrReq createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static GetxattrReq getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetxattrReq>(create);
  static GetxattrReq? _defaultInstance;

  @$pb.TagNumber(1)
  $fixnum.Int64 get ino => $_getI64(0);
  @$pb.TagNumber(1)
  set ino($fixnum.Int64 value) => $_setInt64(0, value);
  @$pb.TagNumber(1)
  $core.bool hasIno() => $_has(0);
  @$pb.TagNumber(1)
  void clearIno() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get name => $_getSZ(1);
  @$pb.TagNumber(2)
  set name($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasName() => $_has(1);
  @$pb.TagNumber(2)
  void clearName() => $_clearField(2);

  @$pb.TagNumber(3)
  $fixnum.Int64 get size => $_getI64(2);
  @$pb.TagNumber(3)
  set size($fixnum.Int64 value) => $_setInt64(2, value);
  @$pb.TagNumber(3)
  $core.bool hasSize() => $_has(2);
  @$pb.TagNumber(3)
  void clearSize() => $_clearField(3);
}

class ListxattrReq extends $pb.GeneratedMessage {
  factory ListxattrReq({
    $fixnum.Int64? ino,
    $fixnum.Int64? size,
  }) {
    final result = create();
    if (ino != null) result.ino = ino;
    if (size != null) result.size = size;
    return result;
  }

  ListxattrReq._();

  factory ListxattrReq.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ListxattrReq.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ListxattrReq',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'bentos.fuse'),
      createEmptyInstance: create)
    ..a<$fixnum.Int64>(1, _omitFieldNames ? '' : 'ino', $pb.PbFieldType.OU6,
        defaultOrMaker: $fixnum.Int64.ZERO)
    ..a<$fixnum.Int64>(2, _omitFieldNames ? '' : 'size', $pb.PbFieldType.OU6,
        defaultOrMaker: $fixnum.Int64.ZERO)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListxattrReq clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListxattrReq copyWith(void Function(ListxattrReq) updates) =>
      super.copyWith((message) => updates(message as ListxattrReq))
          as ListxattrReq;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ListxattrReq create() => ListxattrReq._();
  @$core.override
  ListxattrReq createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ListxattrReq getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ListxattrReq>(create);
  static ListxattrReq? _defaultInstance;

  @$pb.TagNumber(1)
  $fixnum.Int64 get ino => $_getI64(0);
  @$pb.TagNumber(1)
  set ino($fixnum.Int64 value) => $_setInt64(0, value);
  @$pb.TagNumber(1)
  $core.bool hasIno() => $_has(0);
  @$pb.TagNumber(1)
  void clearIno() => $_clearField(1);

  @$pb.TagNumber(2)
  $fixnum.Int64 get size => $_getI64(1);
  @$pb.TagNumber(2)
  set size($fixnum.Int64 value) => $_setInt64(1, value);
  @$pb.TagNumber(2)
  $core.bool hasSize() => $_has(1);
  @$pb.TagNumber(2)
  void clearSize() => $_clearField(2);
}

class RemovexattrReq extends $pb.GeneratedMessage {
  factory RemovexattrReq({
    $fixnum.Int64? ino,
    $core.String? name,
  }) {
    final result = create();
    if (ino != null) result.ino = ino;
    if (name != null) result.name = name;
    return result;
  }

  RemovexattrReq._();

  factory RemovexattrReq.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory RemovexattrReq.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'RemovexattrReq',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'bentos.fuse'),
      createEmptyInstance: create)
    ..a<$fixnum.Int64>(1, _omitFieldNames ? '' : 'ino', $pb.PbFieldType.OU6,
        defaultOrMaker: $fixnum.Int64.ZERO)
    ..aOS(2, _omitFieldNames ? '' : 'name')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RemovexattrReq clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RemovexattrReq copyWith(void Function(RemovexattrReq) updates) =>
      super.copyWith((message) => updates(message as RemovexattrReq))
          as RemovexattrReq;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static RemovexattrReq create() => RemovexattrReq._();
  @$core.override
  RemovexattrReq createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static RemovexattrReq getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<RemovexattrReq>(create);
  static RemovexattrReq? _defaultInstance;

  @$pb.TagNumber(1)
  $fixnum.Int64 get ino => $_getI64(0);
  @$pb.TagNumber(1)
  set ino($fixnum.Int64 value) => $_setInt64(0, value);
  @$pb.TagNumber(1)
  $core.bool hasIno() => $_has(0);
  @$pb.TagNumber(1)
  void clearIno() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get name => $_getSZ(1);
  @$pb.TagNumber(2)
  set name($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasName() => $_has(1);
  @$pb.TagNumber(2)
  void clearName() => $_clearField(2);
}

class AccessReq extends $pb.GeneratedMessage {
  factory AccessReq({
    $fixnum.Int64? ino,
    $core.int? mask,
  }) {
    final result = create();
    if (ino != null) result.ino = ino;
    if (mask != null) result.mask = mask;
    return result;
  }

  AccessReq._();

  factory AccessReq.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory AccessReq.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'AccessReq',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'bentos.fuse'),
      createEmptyInstance: create)
    ..a<$fixnum.Int64>(1, _omitFieldNames ? '' : 'ino', $pb.PbFieldType.OU6,
        defaultOrMaker: $fixnum.Int64.ZERO)
    ..aI(2, _omitFieldNames ? '' : 'mask')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AccessReq clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AccessReq copyWith(void Function(AccessReq) updates) =>
      super.copyWith((message) => updates(message as AccessReq)) as AccessReq;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static AccessReq create() => AccessReq._();
  @$core.override
  AccessReq createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static AccessReq getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<AccessReq>(create);
  static AccessReq? _defaultInstance;

  @$pb.TagNumber(1)
  $fixnum.Int64 get ino => $_getI64(0);
  @$pb.TagNumber(1)
  set ino($fixnum.Int64 value) => $_setInt64(0, value);
  @$pb.TagNumber(1)
  $core.bool hasIno() => $_has(0);
  @$pb.TagNumber(1)
  void clearIno() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.int get mask => $_getIZ(1);
  @$pb.TagNumber(2)
  set mask($core.int value) => $_setSignedInt32(1, value);
  @$pb.TagNumber(2)
  $core.bool hasMask() => $_has(1);
  @$pb.TagNumber(2)
  void clearMask() => $_clearField(2);
}

class CreateReq extends $pb.GeneratedMessage {
  factory CreateReq({
    $fixnum.Int64? parent,
    $core.String? name,
    $core.int? mode,
    $core.int? flags,
  }) {
    final result = create();
    if (parent != null) result.parent = parent;
    if (name != null) result.name = name;
    if (mode != null) result.mode = mode;
    if (flags != null) result.flags = flags;
    return result;
  }

  CreateReq._();

  factory CreateReq.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory CreateReq.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'CreateReq',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'bentos.fuse'),
      createEmptyInstance: create)
    ..a<$fixnum.Int64>(1, _omitFieldNames ? '' : 'parent', $pb.PbFieldType.OU6,
        defaultOrMaker: $fixnum.Int64.ZERO)
    ..aOS(2, _omitFieldNames ? '' : 'name')
    ..aI(3, _omitFieldNames ? '' : 'mode', fieldType: $pb.PbFieldType.OU3)
    ..aI(4, _omitFieldNames ? '' : 'flags')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CreateReq clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CreateReq copyWith(void Function(CreateReq) updates) =>
      super.copyWith((message) => updates(message as CreateReq)) as CreateReq;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static CreateReq create() => CreateReq._();
  @$core.override
  CreateReq createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static CreateReq getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<CreateReq>(create);
  static CreateReq? _defaultInstance;

  @$pb.TagNumber(1)
  $fixnum.Int64 get parent => $_getI64(0);
  @$pb.TagNumber(1)
  set parent($fixnum.Int64 value) => $_setInt64(0, value);
  @$pb.TagNumber(1)
  $core.bool hasParent() => $_has(0);
  @$pb.TagNumber(1)
  void clearParent() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get name => $_getSZ(1);
  @$pb.TagNumber(2)
  set name($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasName() => $_has(1);
  @$pb.TagNumber(2)
  void clearName() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.int get mode => $_getIZ(2);
  @$pb.TagNumber(3)
  set mode($core.int value) => $_setUnsignedInt32(2, value);
  @$pb.TagNumber(3)
  $core.bool hasMode() => $_has(2);
  @$pb.TagNumber(3)
  void clearMode() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.int get flags => $_getIZ(3);
  @$pb.TagNumber(4)
  set flags($core.int value) => $_setSignedInt32(3, value);
  @$pb.TagNumber(4)
  $core.bool hasFlags() => $_has(3);
  @$pb.TagNumber(4)
  void clearFlags() => $_clearField(4);
}

class GetlkReq extends $pb.GeneratedMessage {
  factory GetlkReq({
    $fixnum.Int64? ino,
    FlockInfo? lock,
  }) {
    final result = create();
    if (ino != null) result.ino = ino;
    if (lock != null) result.lock = lock;
    return result;
  }

  GetlkReq._();

  factory GetlkReq.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory GetlkReq.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetlkReq',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'bentos.fuse'),
      createEmptyInstance: create)
    ..a<$fixnum.Int64>(1, _omitFieldNames ? '' : 'ino', $pb.PbFieldType.OU6,
        defaultOrMaker: $fixnum.Int64.ZERO)
    ..aOM<FlockInfo>(2, _omitFieldNames ? '' : 'lock',
        subBuilder: FlockInfo.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetlkReq clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetlkReq copyWith(void Function(GetlkReq) updates) =>
      super.copyWith((message) => updates(message as GetlkReq)) as GetlkReq;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GetlkReq create() => GetlkReq._();
  @$core.override
  GetlkReq createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static GetlkReq getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<GetlkReq>(create);
  static GetlkReq? _defaultInstance;

  @$pb.TagNumber(1)
  $fixnum.Int64 get ino => $_getI64(0);
  @$pb.TagNumber(1)
  set ino($fixnum.Int64 value) => $_setInt64(0, value);
  @$pb.TagNumber(1)
  $core.bool hasIno() => $_has(0);
  @$pb.TagNumber(1)
  void clearIno() => $_clearField(1);

  @$pb.TagNumber(2)
  FlockInfo get lock => $_getN(1);
  @$pb.TagNumber(2)
  set lock(FlockInfo value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasLock() => $_has(1);
  @$pb.TagNumber(2)
  void clearLock() => $_clearField(2);
  @$pb.TagNumber(2)
  FlockInfo ensureLock() => $_ensure(1);
}

class SetlkReq extends $pb.GeneratedMessage {
  factory SetlkReq({
    $fixnum.Int64? ino,
    FlockInfo? lock,
    $core.bool? sleep,
  }) {
    final result = create();
    if (ino != null) result.ino = ino;
    if (lock != null) result.lock = lock;
    if (sleep != null) result.sleep = sleep;
    return result;
  }

  SetlkReq._();

  factory SetlkReq.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory SetlkReq.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'SetlkReq',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'bentos.fuse'),
      createEmptyInstance: create)
    ..a<$fixnum.Int64>(1, _omitFieldNames ? '' : 'ino', $pb.PbFieldType.OU6,
        defaultOrMaker: $fixnum.Int64.ZERO)
    ..aOM<FlockInfo>(2, _omitFieldNames ? '' : 'lock',
        subBuilder: FlockInfo.create)
    ..aOB(3, _omitFieldNames ? '' : 'sleep')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SetlkReq clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SetlkReq copyWith(void Function(SetlkReq) updates) =>
      super.copyWith((message) => updates(message as SetlkReq)) as SetlkReq;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static SetlkReq create() => SetlkReq._();
  @$core.override
  SetlkReq createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static SetlkReq getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<SetlkReq>(create);
  static SetlkReq? _defaultInstance;

  @$pb.TagNumber(1)
  $fixnum.Int64 get ino => $_getI64(0);
  @$pb.TagNumber(1)
  set ino($fixnum.Int64 value) => $_setInt64(0, value);
  @$pb.TagNumber(1)
  $core.bool hasIno() => $_has(0);
  @$pb.TagNumber(1)
  void clearIno() => $_clearField(1);

  @$pb.TagNumber(2)
  FlockInfo get lock => $_getN(1);
  @$pb.TagNumber(2)
  set lock(FlockInfo value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasLock() => $_has(1);
  @$pb.TagNumber(2)
  void clearLock() => $_clearField(2);
  @$pb.TagNumber(2)
  FlockInfo ensureLock() => $_ensure(1);

  @$pb.TagNumber(3)
  $core.bool get sleep => $_getBF(2);
  @$pb.TagNumber(3)
  set sleep($core.bool value) => $_setBool(2, value);
  @$pb.TagNumber(3)
  $core.bool hasSleep() => $_has(2);
  @$pb.TagNumber(3)
  void clearSleep() => $_clearField(3);
}

class BmapReq extends $pb.GeneratedMessage {
  factory BmapReq({
    $fixnum.Int64? ino,
    $fixnum.Int64? blocksize,
    $fixnum.Int64? idx,
  }) {
    final result = create();
    if (ino != null) result.ino = ino;
    if (blocksize != null) result.blocksize = blocksize;
    if (idx != null) result.idx = idx;
    return result;
  }

  BmapReq._();

  factory BmapReq.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory BmapReq.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'BmapReq',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'bentos.fuse'),
      createEmptyInstance: create)
    ..a<$fixnum.Int64>(1, _omitFieldNames ? '' : 'ino', $pb.PbFieldType.OU6,
        defaultOrMaker: $fixnum.Int64.ZERO)
    ..a<$fixnum.Int64>(
        2, _omitFieldNames ? '' : 'blocksize', $pb.PbFieldType.OU6,
        defaultOrMaker: $fixnum.Int64.ZERO)
    ..a<$fixnum.Int64>(3, _omitFieldNames ? '' : 'idx', $pb.PbFieldType.OU6,
        defaultOrMaker: $fixnum.Int64.ZERO)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  BmapReq clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  BmapReq copyWith(void Function(BmapReq) updates) =>
      super.copyWith((message) => updates(message as BmapReq)) as BmapReq;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static BmapReq create() => BmapReq._();
  @$core.override
  BmapReq createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static BmapReq getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<BmapReq>(create);
  static BmapReq? _defaultInstance;

  @$pb.TagNumber(1)
  $fixnum.Int64 get ino => $_getI64(0);
  @$pb.TagNumber(1)
  set ino($fixnum.Int64 value) => $_setInt64(0, value);
  @$pb.TagNumber(1)
  $core.bool hasIno() => $_has(0);
  @$pb.TagNumber(1)
  void clearIno() => $_clearField(1);

  @$pb.TagNumber(2)
  $fixnum.Int64 get blocksize => $_getI64(1);
  @$pb.TagNumber(2)
  set blocksize($fixnum.Int64 value) => $_setInt64(1, value);
  @$pb.TagNumber(2)
  $core.bool hasBlocksize() => $_has(1);
  @$pb.TagNumber(2)
  void clearBlocksize() => $_clearField(2);

  @$pb.TagNumber(3)
  $fixnum.Int64 get idx => $_getI64(2);
  @$pb.TagNumber(3)
  set idx($fixnum.Int64 value) => $_setInt64(2, value);
  @$pb.TagNumber(3)
  $core.bool hasIdx() => $_has(2);
  @$pb.TagNumber(3)
  void clearIdx() => $_clearField(3);
}

class FallocateReq extends $pb.GeneratedMessage {
  factory FallocateReq({
    $fixnum.Int64? ino,
    $core.int? mode,
    $fixnum.Int64? offset,
    $fixnum.Int64? length,
  }) {
    final result = create();
    if (ino != null) result.ino = ino;
    if (mode != null) result.mode = mode;
    if (offset != null) result.offset = offset;
    if (length != null) result.length = length;
    return result;
  }

  FallocateReq._();

  factory FallocateReq.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory FallocateReq.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'FallocateReq',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'bentos.fuse'),
      createEmptyInstance: create)
    ..a<$fixnum.Int64>(1, _omitFieldNames ? '' : 'ino', $pb.PbFieldType.OU6,
        defaultOrMaker: $fixnum.Int64.ZERO)
    ..aI(2, _omitFieldNames ? '' : 'mode')
    ..aInt64(3, _omitFieldNames ? '' : 'offset')
    ..aInt64(4, _omitFieldNames ? '' : 'length')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  FallocateReq clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  FallocateReq copyWith(void Function(FallocateReq) updates) =>
      super.copyWith((message) => updates(message as FallocateReq))
          as FallocateReq;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static FallocateReq create() => FallocateReq._();
  @$core.override
  FallocateReq createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static FallocateReq getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<FallocateReq>(create);
  static FallocateReq? _defaultInstance;

  @$pb.TagNumber(1)
  $fixnum.Int64 get ino => $_getI64(0);
  @$pb.TagNumber(1)
  set ino($fixnum.Int64 value) => $_setInt64(0, value);
  @$pb.TagNumber(1)
  $core.bool hasIno() => $_has(0);
  @$pb.TagNumber(1)
  void clearIno() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.int get mode => $_getIZ(1);
  @$pb.TagNumber(2)
  set mode($core.int value) => $_setSignedInt32(1, value);
  @$pb.TagNumber(2)
  $core.bool hasMode() => $_has(1);
  @$pb.TagNumber(2)
  void clearMode() => $_clearField(2);

  @$pb.TagNumber(3)
  $fixnum.Int64 get offset => $_getI64(2);
  @$pb.TagNumber(3)
  set offset($fixnum.Int64 value) => $_setInt64(2, value);
  @$pb.TagNumber(3)
  $core.bool hasOffset() => $_has(2);
  @$pb.TagNumber(3)
  void clearOffset() => $_clearField(3);

  @$pb.TagNumber(4)
  $fixnum.Int64 get length => $_getI64(3);
  @$pb.TagNumber(4)
  set length($fixnum.Int64 value) => $_setInt64(3, value);
  @$pb.TagNumber(4)
  $core.bool hasLength() => $_has(3);
  @$pb.TagNumber(4)
  void clearLength() => $_clearField(4);
}

class ReaddirplusReq extends $pb.GeneratedMessage {
  factory ReaddirplusReq({
    $fixnum.Int64? ino,
    $fixnum.Int64? size,
    $fixnum.Int64? offset,
  }) {
    final result = create();
    if (ino != null) result.ino = ino;
    if (size != null) result.size = size;
    if (offset != null) result.offset = offset;
    return result;
  }

  ReaddirplusReq._();

  factory ReaddirplusReq.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ReaddirplusReq.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ReaddirplusReq',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'bentos.fuse'),
      createEmptyInstance: create)
    ..a<$fixnum.Int64>(1, _omitFieldNames ? '' : 'ino', $pb.PbFieldType.OU6,
        defaultOrMaker: $fixnum.Int64.ZERO)
    ..a<$fixnum.Int64>(2, _omitFieldNames ? '' : 'size', $pb.PbFieldType.OU6,
        defaultOrMaker: $fixnum.Int64.ZERO)
    ..aInt64(3, _omitFieldNames ? '' : 'offset')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ReaddirplusReq clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ReaddirplusReq copyWith(void Function(ReaddirplusReq) updates) =>
      super.copyWith((message) => updates(message as ReaddirplusReq))
          as ReaddirplusReq;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ReaddirplusReq create() => ReaddirplusReq._();
  @$core.override
  ReaddirplusReq createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ReaddirplusReq getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ReaddirplusReq>(create);
  static ReaddirplusReq? _defaultInstance;

  @$pb.TagNumber(1)
  $fixnum.Int64 get ino => $_getI64(0);
  @$pb.TagNumber(1)
  set ino($fixnum.Int64 value) => $_setInt64(0, value);
  @$pb.TagNumber(1)
  $core.bool hasIno() => $_has(0);
  @$pb.TagNumber(1)
  void clearIno() => $_clearField(1);

  @$pb.TagNumber(2)
  $fixnum.Int64 get size => $_getI64(1);
  @$pb.TagNumber(2)
  set size($fixnum.Int64 value) => $_setInt64(1, value);
  @$pb.TagNumber(2)
  $core.bool hasSize() => $_has(1);
  @$pb.TagNumber(2)
  void clearSize() => $_clearField(2);

  @$pb.TagNumber(3)
  $fixnum.Int64 get offset => $_getI64(2);
  @$pb.TagNumber(3)
  set offset($fixnum.Int64 value) => $_setInt64(2, value);
  @$pb.TagNumber(3)
  $core.bool hasOffset() => $_has(2);
  @$pb.TagNumber(3)
  void clearOffset() => $_clearField(3);
}

class CopyFileRangeReq extends $pb.GeneratedMessage {
  factory CopyFileRangeReq({
    $fixnum.Int64? inoIn,
    $fixnum.Int64? offIn,
    $fixnum.Int64? inoOut,
    $fixnum.Int64? offOut,
    $fixnum.Int64? len,
    $fixnum.Int64? flags,
    $fixnum.Int64? fhIn,
    $fixnum.Int64? fhOut,
  }) {
    final result = create();
    if (inoIn != null) result.inoIn = inoIn;
    if (offIn != null) result.offIn = offIn;
    if (inoOut != null) result.inoOut = inoOut;
    if (offOut != null) result.offOut = offOut;
    if (len != null) result.len = len;
    if (flags != null) result.flags = flags;
    if (fhIn != null) result.fhIn = fhIn;
    if (fhOut != null) result.fhOut = fhOut;
    return result;
  }

  CopyFileRangeReq._();

  factory CopyFileRangeReq.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory CopyFileRangeReq.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'CopyFileRangeReq',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'bentos.fuse'),
      createEmptyInstance: create)
    ..a<$fixnum.Int64>(1, _omitFieldNames ? '' : 'inoIn', $pb.PbFieldType.OU6,
        defaultOrMaker: $fixnum.Int64.ZERO)
    ..aInt64(2, _omitFieldNames ? '' : 'offIn')
    ..a<$fixnum.Int64>(3, _omitFieldNames ? '' : 'inoOut', $pb.PbFieldType.OU6,
        defaultOrMaker: $fixnum.Int64.ZERO)
    ..aInt64(4, _omitFieldNames ? '' : 'offOut')
    ..a<$fixnum.Int64>(5, _omitFieldNames ? '' : 'len', $pb.PbFieldType.OU6,
        defaultOrMaker: $fixnum.Int64.ZERO)
    ..a<$fixnum.Int64>(6, _omitFieldNames ? '' : 'flags', $pb.PbFieldType.OU6,
        defaultOrMaker: $fixnum.Int64.ZERO)
    ..a<$fixnum.Int64>(7, _omitFieldNames ? '' : 'fhIn', $pb.PbFieldType.OU6,
        defaultOrMaker: $fixnum.Int64.ZERO)
    ..a<$fixnum.Int64>(8, _omitFieldNames ? '' : 'fhOut', $pb.PbFieldType.OU6,
        defaultOrMaker: $fixnum.Int64.ZERO)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CopyFileRangeReq clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CopyFileRangeReq copyWith(void Function(CopyFileRangeReq) updates) =>
      super.copyWith((message) => updates(message as CopyFileRangeReq))
          as CopyFileRangeReq;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static CopyFileRangeReq create() => CopyFileRangeReq._();
  @$core.override
  CopyFileRangeReq createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static CopyFileRangeReq getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<CopyFileRangeReq>(create);
  static CopyFileRangeReq? _defaultInstance;

  @$pb.TagNumber(1)
  $fixnum.Int64 get inoIn => $_getI64(0);
  @$pb.TagNumber(1)
  set inoIn($fixnum.Int64 value) => $_setInt64(0, value);
  @$pb.TagNumber(1)
  $core.bool hasInoIn() => $_has(0);
  @$pb.TagNumber(1)
  void clearInoIn() => $_clearField(1);

  @$pb.TagNumber(2)
  $fixnum.Int64 get offIn => $_getI64(1);
  @$pb.TagNumber(2)
  set offIn($fixnum.Int64 value) => $_setInt64(1, value);
  @$pb.TagNumber(2)
  $core.bool hasOffIn() => $_has(1);
  @$pb.TagNumber(2)
  void clearOffIn() => $_clearField(2);

  @$pb.TagNumber(3)
  $fixnum.Int64 get inoOut => $_getI64(2);
  @$pb.TagNumber(3)
  set inoOut($fixnum.Int64 value) => $_setInt64(2, value);
  @$pb.TagNumber(3)
  $core.bool hasInoOut() => $_has(2);
  @$pb.TagNumber(3)
  void clearInoOut() => $_clearField(3);

  @$pb.TagNumber(4)
  $fixnum.Int64 get offOut => $_getI64(3);
  @$pb.TagNumber(4)
  set offOut($fixnum.Int64 value) => $_setInt64(3, value);
  @$pb.TagNumber(4)
  $core.bool hasOffOut() => $_has(3);
  @$pb.TagNumber(4)
  void clearOffOut() => $_clearField(4);

  @$pb.TagNumber(5)
  $fixnum.Int64 get len => $_getI64(4);
  @$pb.TagNumber(5)
  set len($fixnum.Int64 value) => $_setInt64(4, value);
  @$pb.TagNumber(5)
  $core.bool hasLen() => $_has(4);
  @$pb.TagNumber(5)
  void clearLen() => $_clearField(5);

  @$pb.TagNumber(6)
  $fixnum.Int64 get flags => $_getI64(5);
  @$pb.TagNumber(6)
  set flags($fixnum.Int64 value) => $_setInt64(5, value);
  @$pb.TagNumber(6)
  $core.bool hasFlags() => $_has(5);
  @$pb.TagNumber(6)
  void clearFlags() => $_clearField(6);

  /// fh_in and fh_out carried via separate file_info if needed
  @$pb.TagNumber(7)
  $fixnum.Int64 get fhIn => $_getI64(6);
  @$pb.TagNumber(7)
  set fhIn($fixnum.Int64 value) => $_setInt64(6, value);
  @$pb.TagNumber(7)
  $core.bool hasFhIn() => $_has(6);
  @$pb.TagNumber(7)
  void clearFhIn() => $_clearField(7);

  @$pb.TagNumber(8)
  $fixnum.Int64 get fhOut => $_getI64(7);
  @$pb.TagNumber(8)
  set fhOut($fixnum.Int64 value) => $_setInt64(7, value);
  @$pb.TagNumber(8)
  $core.bool hasFhOut() => $_has(7);
  @$pb.TagNumber(8)
  void clearFhOut() => $_clearField(8);
}

class LseekReq extends $pb.GeneratedMessage {
  factory LseekReq({
    $fixnum.Int64? offset,
    $core.int? whence,
  }) {
    final result = create();
    if (offset != null) result.offset = offset;
    if (whence != null) result.whence = whence;
    return result;
  }

  LseekReq._();

  factory LseekReq.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory LseekReq.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'LseekReq',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'bentos.fuse'),
      createEmptyInstance: create)
    ..aInt64(1, _omitFieldNames ? '' : 'offset')
    ..aI(2, _omitFieldNames ? '' : 'whence')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  LseekReq clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  LseekReq copyWith(void Function(LseekReq) updates) =>
      super.copyWith((message) => updates(message as LseekReq)) as LseekReq;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static LseekReq create() => LseekReq._();
  @$core.override
  LseekReq createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static LseekReq getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<LseekReq>(create);
  static LseekReq? _defaultInstance;

  @$pb.TagNumber(1)
  $fixnum.Int64 get offset => $_getI64(0);
  @$pb.TagNumber(1)
  set offset($fixnum.Int64 value) => $_setInt64(0, value);
  @$pb.TagNumber(1)
  $core.bool hasOffset() => $_has(0);
  @$pb.TagNumber(1)
  void clearOffset() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.int get whence => $_getIZ(1);
  @$pb.TagNumber(2)
  set whence($core.int value) => $_setSignedInt32(1, value);
  @$pb.TagNumber(2)
  $core.bool hasWhence() => $_has(1);
  @$pb.TagNumber(2)
  void clearWhence() => $_clearField(2);
}

enum FuseResponse_Reply {
  open,
  buf,
  write,
  ioctl,
  poll,
  entry,
  attr,
  readlink,
  statfs,
  xattr,
  create_21,
  lock,
  bmap,
  lseek,
  readdir,
  notSet
}

class FuseResponse extends $pb.GeneratedMessage {
  factory FuseResponse({
    $core.int? err,
    OpenReply? open,
    BufReply? buf,
    WriteReply? write,
    IoctlReply? ioctl,
    PollReply? poll,
    EntryReply? entry,
    AttrReply? attr,
    ReadlinkReply? readlink,
    StatfsReply? statfs,
    XattrReply? xattr,
    CreateReply? create_21,
    LockReply? lock,
    BmapReply? bmap,
    LseekReply? lseek,
    ReaddirReply? readdir,
  }) {
    final result = create();
    if (err != null) result.err = err;
    if (open != null) result.open = open;
    if (buf != null) result.buf = buf;
    if (write != null) result.write = write;
    if (ioctl != null) result.ioctl = ioctl;
    if (poll != null) result.poll = poll;
    if (entry != null) result.entry = entry;
    if (attr != null) result.attr = attr;
    if (readlink != null) result.readlink = readlink;
    if (statfs != null) result.statfs = statfs;
    if (xattr != null) result.xattr = xattr;
    if (create_21 != null) result.create_21 = create_21;
    if (lock != null) result.lock = lock;
    if (bmap != null) result.bmap = bmap;
    if (lseek != null) result.lseek = lseek;
    if (readdir != null) result.readdir = readdir;
    return result;
  }

  FuseResponse._();

  factory FuseResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory FuseResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static const $core.Map<$core.int, FuseResponse_Reply>
      _FuseResponse_ReplyByTag = {
    8: FuseResponse_Reply.open,
    9: FuseResponse_Reply.buf,
    10: FuseResponse_Reply.write,
    11: FuseResponse_Reply.ioctl,
    12: FuseResponse_Reply.poll,
    16: FuseResponse_Reply.entry,
    17: FuseResponse_Reply.attr,
    18: FuseResponse_Reply.readlink,
    19: FuseResponse_Reply.statfs,
    20: FuseResponse_Reply.xattr,
    21: FuseResponse_Reply.create_21,
    22: FuseResponse_Reply.lock,
    23: FuseResponse_Reply.bmap,
    24: FuseResponse_Reply.lseek,
    25: FuseResponse_Reply.readdir,
    0: FuseResponse_Reply.notSet
  };
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'FuseResponse',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'bentos.fuse'),
      createEmptyInstance: create)
    ..oo(0, [8, 9, 10, 11, 12, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25])
    ..aI(1, _omitFieldNames ? '' : 'err')
    ..aOM<OpenReply>(8, _omitFieldNames ? '' : 'open',
        subBuilder: OpenReply.create)
    ..aOM<BufReply>(9, _omitFieldNames ? '' : 'buf',
        subBuilder: BufReply.create)
    ..aOM<WriteReply>(10, _omitFieldNames ? '' : 'write',
        subBuilder: WriteReply.create)
    ..aOM<IoctlReply>(11, _omitFieldNames ? '' : 'ioctl',
        subBuilder: IoctlReply.create)
    ..aOM<PollReply>(12, _omitFieldNames ? '' : 'poll',
        subBuilder: PollReply.create)
    ..aOM<EntryReply>(16, _omitFieldNames ? '' : 'entry',
        subBuilder: EntryReply.create)
    ..aOM<AttrReply>(17, _omitFieldNames ? '' : 'attr',
        subBuilder: AttrReply.create)
    ..aOM<ReadlinkReply>(18, _omitFieldNames ? '' : 'readlink',
        subBuilder: ReadlinkReply.create)
    ..aOM<StatfsReply>(19, _omitFieldNames ? '' : 'statfs',
        subBuilder: StatfsReply.create)
    ..aOM<XattrReply>(20, _omitFieldNames ? '' : 'xattr',
        subBuilder: XattrReply.create)
    ..aOM<CreateReply>(21, _omitFieldNames ? '' : 'create',
        subBuilder: CreateReply.create)
    ..aOM<LockReply>(22, _omitFieldNames ? '' : 'lock',
        subBuilder: LockReply.create)
    ..aOM<BmapReply>(23, _omitFieldNames ? '' : 'bmap',
        subBuilder: BmapReply.create)
    ..aOM<LseekReply>(24, _omitFieldNames ? '' : 'lseek',
        subBuilder: LseekReply.create)
    ..aOM<ReaddirReply>(25, _omitFieldNames ? '' : 'readdir',
        subBuilder: ReaddirReply.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  FuseResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  FuseResponse copyWith(void Function(FuseResponse) updates) =>
      super.copyWith((message) => updates(message as FuseResponse))
          as FuseResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static FuseResponse create() => FuseResponse._();
  @$core.override
  FuseResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static FuseResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<FuseResponse>(create);
  static FuseResponse? _defaultInstance;

  @$pb.TagNumber(8)
  @$pb.TagNumber(9)
  @$pb.TagNumber(10)
  @$pb.TagNumber(11)
  @$pb.TagNumber(12)
  @$pb.TagNumber(16)
  @$pb.TagNumber(17)
  @$pb.TagNumber(18)
  @$pb.TagNumber(19)
  @$pb.TagNumber(20)
  @$pb.TagNumber(21)
  @$pb.TagNumber(22)
  @$pb.TagNumber(23)
  @$pb.TagNumber(24)
  @$pb.TagNumber(25)
  FuseResponse_Reply whichReply() => _FuseResponse_ReplyByTag[$_whichOneof(0)]!;
  @$pb.TagNumber(8)
  @$pb.TagNumber(9)
  @$pb.TagNumber(10)
  @$pb.TagNumber(11)
  @$pb.TagNumber(12)
  @$pb.TagNumber(16)
  @$pb.TagNumber(17)
  @$pb.TagNumber(18)
  @$pb.TagNumber(19)
  @$pb.TagNumber(20)
  @$pb.TagNumber(21)
  @$pb.TagNumber(22)
  @$pb.TagNumber(23)
  @$pb.TagNumber(24)
  @$pb.TagNumber(25)
  void clearReply() => $_clearField($_whichOneof(0));

  /// 0 = success. Positive = errno (driver MUST use errno values, not negated).
  /// When non-zero, the fuse channel calls fuse_reply_err(req, errno).
  @$pb.TagNumber(1)
  $core.int get err => $_getIZ(0);
  @$pb.TagNumber(1)
  set err($core.int value) => $_setSignedInt32(0, value);
  @$pb.TagNumber(1)
  $core.bool hasErr() => $_has(0);
  @$pb.TagNumber(1)
  void clearErr() => $_clearField(1);

  @$pb.TagNumber(8)
  OpenReply get open => $_getN(1);
  @$pb.TagNumber(8)
  set open(OpenReply value) => $_setField(8, value);
  @$pb.TagNumber(8)
  $core.bool hasOpen() => $_has(1);
  @$pb.TagNumber(8)
  void clearOpen() => $_clearField(8);
  @$pb.TagNumber(8)
  OpenReply ensureOpen() => $_ensure(1);

  @$pb.TagNumber(9)
  BufReply get buf => $_getN(2);
  @$pb.TagNumber(9)
  set buf(BufReply value) => $_setField(9, value);
  @$pb.TagNumber(9)
  $core.bool hasBuf() => $_has(2);
  @$pb.TagNumber(9)
  void clearBuf() => $_clearField(9);
  @$pb.TagNumber(9)
  BufReply ensureBuf() => $_ensure(2);

  @$pb.TagNumber(10)
  WriteReply get write => $_getN(3);
  @$pb.TagNumber(10)
  set write(WriteReply value) => $_setField(10, value);
  @$pb.TagNumber(10)
  $core.bool hasWrite() => $_has(3);
  @$pb.TagNumber(10)
  void clearWrite() => $_clearField(10);
  @$pb.TagNumber(10)
  WriteReply ensureWrite() => $_ensure(3);

  @$pb.TagNumber(11)
  IoctlReply get ioctl => $_getN(4);
  @$pb.TagNumber(11)
  set ioctl(IoctlReply value) => $_setField(11, value);
  @$pb.TagNumber(11)
  $core.bool hasIoctl() => $_has(4);
  @$pb.TagNumber(11)
  void clearIoctl() => $_clearField(11);
  @$pb.TagNumber(11)
  IoctlReply ensureIoctl() => $_ensure(4);

  @$pb.TagNumber(12)
  PollReply get poll => $_getN(5);
  @$pb.TagNumber(12)
  set poll(PollReply value) => $_setField(12, value);
  @$pb.TagNumber(12)
  $core.bool hasPoll() => $_has(5);
  @$pb.TagNumber(12)
  void clearPoll() => $_clearField(12);
  @$pb.TagNumber(12)
  PollReply ensurePoll() => $_ensure(5);

  /// — FUSE-only replies —
  @$pb.TagNumber(16)
  EntryReply get entry => $_getN(6);
  @$pb.TagNumber(16)
  set entry(EntryReply value) => $_setField(16, value);
  @$pb.TagNumber(16)
  $core.bool hasEntry() => $_has(6);
  @$pb.TagNumber(16)
  void clearEntry() => $_clearField(16);
  @$pb.TagNumber(16)
  EntryReply ensureEntry() => $_ensure(6);

  @$pb.TagNumber(17)
  AttrReply get attr => $_getN(7);
  @$pb.TagNumber(17)
  set attr(AttrReply value) => $_setField(17, value);
  @$pb.TagNumber(17)
  $core.bool hasAttr() => $_has(7);
  @$pb.TagNumber(17)
  void clearAttr() => $_clearField(17);
  @$pb.TagNumber(17)
  AttrReply ensureAttr() => $_ensure(7);

  @$pb.TagNumber(18)
  ReadlinkReply get readlink => $_getN(8);
  @$pb.TagNumber(18)
  set readlink(ReadlinkReply value) => $_setField(18, value);
  @$pb.TagNumber(18)
  $core.bool hasReadlink() => $_has(8);
  @$pb.TagNumber(18)
  void clearReadlink() => $_clearField(18);
  @$pb.TagNumber(18)
  ReadlinkReply ensureReadlink() => $_ensure(8);

  @$pb.TagNumber(19)
  StatfsReply get statfs => $_getN(9);
  @$pb.TagNumber(19)
  set statfs(StatfsReply value) => $_setField(19, value);
  @$pb.TagNumber(19)
  $core.bool hasStatfs() => $_has(9);
  @$pb.TagNumber(19)
  void clearStatfs() => $_clearField(19);
  @$pb.TagNumber(19)
  StatfsReply ensureStatfs() => $_ensure(9);

  @$pb.TagNumber(20)
  XattrReply get xattr => $_getN(10);
  @$pb.TagNumber(20)
  set xattr(XattrReply value) => $_setField(20, value);
  @$pb.TagNumber(20)
  $core.bool hasXattr() => $_has(10);
  @$pb.TagNumber(20)
  void clearXattr() => $_clearField(20);
  @$pb.TagNumber(20)
  XattrReply ensureXattr() => $_ensure(10);

  @$pb.TagNumber(21)
  CreateReply get create_21 => $_getN(11);
  @$pb.TagNumber(21)
  set create_21(CreateReply value) => $_setField(21, value);
  @$pb.TagNumber(21)
  $core.bool hasCreate_21() => $_has(11);
  @$pb.TagNumber(21)
  void clearCreate_21() => $_clearField(21);
  @$pb.TagNumber(21)
  CreateReply ensureCreate_21() => $_ensure(11);

  @$pb.TagNumber(22)
  LockReply get lock => $_getN(12);
  @$pb.TagNumber(22)
  set lock(LockReply value) => $_setField(22, value);
  @$pb.TagNumber(22)
  $core.bool hasLock() => $_has(12);
  @$pb.TagNumber(22)
  void clearLock() => $_clearField(22);
  @$pb.TagNumber(22)
  LockReply ensureLock() => $_ensure(12);

  @$pb.TagNumber(23)
  BmapReply get bmap => $_getN(13);
  @$pb.TagNumber(23)
  set bmap(BmapReply value) => $_setField(23, value);
  @$pb.TagNumber(23)
  $core.bool hasBmap() => $_has(13);
  @$pb.TagNumber(23)
  void clearBmap() => $_clearField(23);
  @$pb.TagNumber(23)
  BmapReply ensureBmap() => $_ensure(13);

  @$pb.TagNumber(24)
  LseekReply get lseek => $_getN(14);
  @$pb.TagNumber(24)
  set lseek(LseekReply value) => $_setField(24, value);
  @$pb.TagNumber(24)
  $core.bool hasLseek() => $_has(14);
  @$pb.TagNumber(24)
  void clearLseek() => $_clearField(24);
  @$pb.TagNumber(24)
  LseekReply ensureLseek() => $_ensure(14);

  @$pb.TagNumber(25)
  ReaddirReply get readdir => $_getN(15);
  @$pb.TagNumber(25)
  set readdir(ReaddirReply value) => $_setField(25, value);
  @$pb.TagNumber(25)
  $core.bool hasReaddir() => $_has(15);
  @$pb.TagNumber(25)
  void clearReaddir() => $_clearField(25);
  @$pb.TagNumber(25)
  ReaddirReply ensureReaddir() => $_ensure(15);
}

class OpenReply extends $pb.GeneratedMessage {
  factory OpenReply({
    $core.int? flags,
    $core.int? bitfields,
  }) {
    final result = create();
    if (flags != null) result.flags = flags;
    if (bitfields != null) result.bitfields = bitfields;
    return result;
  }

  OpenReply._();

  factory OpenReply.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory OpenReply.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'OpenReply',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'bentos.fuse'),
      createEmptyInstance: create)
    ..aI(1, _omitFieldNames ? '' : 'flags')
    ..aI(2, _omitFieldNames ? '' : 'bitfields', fieldType: $pb.PbFieldType.OU3)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  OpenReply clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  OpenReply copyWith(void Function(OpenReply) updates) =>
      super.copyWith((message) => updates(message as OpenReply)) as OpenReply;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static OpenReply create() => OpenReply._();
  @$core.override
  OpenReply createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static OpenReply getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<OpenReply>(create);
  static OpenReply? _defaultInstance;

  @$pb.TagNumber(1)
  $core.int get flags => $_getIZ(0);
  @$pb.TagNumber(1)
  set flags($core.int value) => $_setSignedInt32(0, value);
  @$pb.TagNumber(1)
  $core.bool hasFlags() => $_has(0);
  @$pb.TagNumber(1)
  void clearFlags() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.int get bitfields => $_getIZ(1);
  @$pb.TagNumber(2)
  set bitfields($core.int value) => $_setUnsignedInt32(1, value);
  @$pb.TagNumber(2)
  $core.bool hasBitfields() => $_has(1);
  @$pb.TagNumber(2)
  void clearBitfields() => $_clearField(2);
}

class BufReply extends $pb.GeneratedMessage {
  factory BufReply({
    $core.List<$core.int>? data,
  }) {
    final result = create();
    if (data != null) result.data = data;
    return result;
  }

  BufReply._();

  factory BufReply.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory BufReply.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'BufReply',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'bentos.fuse'),
      createEmptyInstance: create)
    ..a<$core.List<$core.int>>(
        1, _omitFieldNames ? '' : 'data', $pb.PbFieldType.OY)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  BufReply clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  BufReply copyWith(void Function(BufReply) updates) =>
      super.copyWith((message) => updates(message as BufReply)) as BufReply;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static BufReply create() => BufReply._();
  @$core.override
  BufReply createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static BufReply getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<BufReply>(create);
  static BufReply? _defaultInstance;

  @$pb.TagNumber(1)
  $core.List<$core.int> get data => $_getN(0);
  @$pb.TagNumber(1)
  set data($core.List<$core.int> value) => $_setBytes(0, value);
  @$pb.TagNumber(1)
  $core.bool hasData() => $_has(0);
  @$pb.TagNumber(1)
  void clearData() => $_clearField(1);
}

class WriteReply extends $pb.GeneratedMessage {
  factory WriteReply({
    $fixnum.Int64? count,
  }) {
    final result = create();
    if (count != null) result.count = count;
    return result;
  }

  WriteReply._();

  factory WriteReply.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory WriteReply.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'WriteReply',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'bentos.fuse'),
      createEmptyInstance: create)
    ..a<$fixnum.Int64>(1, _omitFieldNames ? '' : 'count', $pb.PbFieldType.OU6,
        defaultOrMaker: $fixnum.Int64.ZERO)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  WriteReply clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  WriteReply copyWith(void Function(WriteReply) updates) =>
      super.copyWith((message) => updates(message as WriteReply)) as WriteReply;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static WriteReply create() => WriteReply._();
  @$core.override
  WriteReply createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static WriteReply getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<WriteReply>(create);
  static WriteReply? _defaultInstance;

  @$pb.TagNumber(1)
  $fixnum.Int64 get count => $_getI64(0);
  @$pb.TagNumber(1)
  set count($fixnum.Int64 value) => $_setInt64(0, value);
  @$pb.TagNumber(1)
  $core.bool hasCount() => $_has(0);
  @$pb.TagNumber(1)
  void clearCount() => $_clearField(1);
}

class IoctlReply extends $pb.GeneratedMessage {
  factory IoctlReply({
    $core.int? result,
    $core.List<$core.int>? buf,
  }) {
    final result$ = create();
    if (result != null) result$.result = result;
    if (buf != null) result$.buf = buf;
    return result$;
  }

  IoctlReply._();

  factory IoctlReply.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory IoctlReply.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'IoctlReply',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'bentos.fuse'),
      createEmptyInstance: create)
    ..aI(1, _omitFieldNames ? '' : 'result')
    ..a<$core.List<$core.int>>(
        2, _omitFieldNames ? '' : 'buf', $pb.PbFieldType.OY)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  IoctlReply clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  IoctlReply copyWith(void Function(IoctlReply) updates) =>
      super.copyWith((message) => updates(message as IoctlReply)) as IoctlReply;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static IoctlReply create() => IoctlReply._();
  @$core.override
  IoctlReply createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static IoctlReply getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<IoctlReply>(create);
  static IoctlReply? _defaultInstance;

  @$pb.TagNumber(1)
  $core.int get result => $_getIZ(0);
  @$pb.TagNumber(1)
  set result($core.int value) => $_setSignedInt32(0, value);
  @$pb.TagNumber(1)
  $core.bool hasResult() => $_has(0);
  @$pb.TagNumber(1)
  void clearResult() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.List<$core.int> get buf => $_getN(1);
  @$pb.TagNumber(2)
  set buf($core.List<$core.int> value) => $_setBytes(1, value);
  @$pb.TagNumber(2)
  $core.bool hasBuf() => $_has(1);
  @$pb.TagNumber(2)
  void clearBuf() => $_clearField(2);
}

class PollReply extends $pb.GeneratedMessage {
  factory PollReply({
    $core.int? revents,
  }) {
    final result = create();
    if (revents != null) result.revents = revents;
    return result;
  }

  PollReply._();

  factory PollReply.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory PollReply.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'PollReply',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'bentos.fuse'),
      createEmptyInstance: create)
    ..aI(1, _omitFieldNames ? '' : 'revents', fieldType: $pb.PbFieldType.OU3)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PollReply clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PollReply copyWith(void Function(PollReply) updates) =>
      super.copyWith((message) => updates(message as PollReply)) as PollReply;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static PollReply create() => PollReply._();
  @$core.override
  PollReply createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static PollReply getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<PollReply>(create);
  static PollReply? _defaultInstance;

  @$pb.TagNumber(1)
  $core.int get revents => $_getIZ(0);
  @$pb.TagNumber(1)
  set revents($core.int value) => $_setUnsignedInt32(0, value);
  @$pb.TagNumber(1)
  $core.bool hasRevents() => $_has(0);
  @$pb.TagNumber(1)
  void clearRevents() => $_clearField(1);
}

class EntryReply extends $pb.GeneratedMessage {
  factory EntryReply({
    $fixnum.Int64? ino,
    $fixnum.Int64? generation,
    StatAttr? attr,
    $core.double? attrTimeout,
    $core.double? entryTimeout,
  }) {
    final result = create();
    if (ino != null) result.ino = ino;
    if (generation != null) result.generation = generation;
    if (attr != null) result.attr = attr;
    if (attrTimeout != null) result.attrTimeout = attrTimeout;
    if (entryTimeout != null) result.entryTimeout = entryTimeout;
    return result;
  }

  EntryReply._();

  factory EntryReply.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory EntryReply.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'EntryReply',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'bentos.fuse'),
      createEmptyInstance: create)
    ..a<$fixnum.Int64>(1, _omitFieldNames ? '' : 'ino', $pb.PbFieldType.OU6,
        defaultOrMaker: $fixnum.Int64.ZERO)
    ..a<$fixnum.Int64>(
        2, _omitFieldNames ? '' : 'generation', $pb.PbFieldType.OU6,
        defaultOrMaker: $fixnum.Int64.ZERO)
    ..aOM<StatAttr>(3, _omitFieldNames ? '' : 'attr',
        subBuilder: StatAttr.create)
    ..aD(4, _omitFieldNames ? '' : 'attrTimeout')
    ..aD(5, _omitFieldNames ? '' : 'entryTimeout')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  EntryReply clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  EntryReply copyWith(void Function(EntryReply) updates) =>
      super.copyWith((message) => updates(message as EntryReply)) as EntryReply;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static EntryReply create() => EntryReply._();
  @$core.override
  EntryReply createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static EntryReply getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<EntryReply>(create);
  static EntryReply? _defaultInstance;

  @$pb.TagNumber(1)
  $fixnum.Int64 get ino => $_getI64(0);
  @$pb.TagNumber(1)
  set ino($fixnum.Int64 value) => $_setInt64(0, value);
  @$pb.TagNumber(1)
  $core.bool hasIno() => $_has(0);
  @$pb.TagNumber(1)
  void clearIno() => $_clearField(1);

  @$pb.TagNumber(2)
  $fixnum.Int64 get generation => $_getI64(1);
  @$pb.TagNumber(2)
  set generation($fixnum.Int64 value) => $_setInt64(1, value);
  @$pb.TagNumber(2)
  $core.bool hasGeneration() => $_has(1);
  @$pb.TagNumber(2)
  void clearGeneration() => $_clearField(2);

  @$pb.TagNumber(3)
  StatAttr get attr => $_getN(2);
  @$pb.TagNumber(3)
  set attr(StatAttr value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasAttr() => $_has(2);
  @$pb.TagNumber(3)
  void clearAttr() => $_clearField(3);
  @$pb.TagNumber(3)
  StatAttr ensureAttr() => $_ensure(2);

  @$pb.TagNumber(4)
  $core.double get attrTimeout => $_getN(3);
  @$pb.TagNumber(4)
  set attrTimeout($core.double value) => $_setDouble(3, value);
  @$pb.TagNumber(4)
  $core.bool hasAttrTimeout() => $_has(3);
  @$pb.TagNumber(4)
  void clearAttrTimeout() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.double get entryTimeout => $_getN(4);
  @$pb.TagNumber(5)
  set entryTimeout($core.double value) => $_setDouble(4, value);
  @$pb.TagNumber(5)
  $core.bool hasEntryTimeout() => $_has(4);
  @$pb.TagNumber(5)
  void clearEntryTimeout() => $_clearField(5);
}

class AttrReply extends $pb.GeneratedMessage {
  factory AttrReply({
    StatAttr? attr,
    $core.double? attrTimeout,
  }) {
    final result = create();
    if (attr != null) result.attr = attr;
    if (attrTimeout != null) result.attrTimeout = attrTimeout;
    return result;
  }

  AttrReply._();

  factory AttrReply.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory AttrReply.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'AttrReply',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'bentos.fuse'),
      createEmptyInstance: create)
    ..aOM<StatAttr>(1, _omitFieldNames ? '' : 'attr',
        subBuilder: StatAttr.create)
    ..aD(2, _omitFieldNames ? '' : 'attrTimeout')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AttrReply clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AttrReply copyWith(void Function(AttrReply) updates) =>
      super.copyWith((message) => updates(message as AttrReply)) as AttrReply;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static AttrReply create() => AttrReply._();
  @$core.override
  AttrReply createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static AttrReply getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<AttrReply>(create);
  static AttrReply? _defaultInstance;

  @$pb.TagNumber(1)
  StatAttr get attr => $_getN(0);
  @$pb.TagNumber(1)
  set attr(StatAttr value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasAttr() => $_has(0);
  @$pb.TagNumber(1)
  void clearAttr() => $_clearField(1);
  @$pb.TagNumber(1)
  StatAttr ensureAttr() => $_ensure(0);

  @$pb.TagNumber(2)
  $core.double get attrTimeout => $_getN(1);
  @$pb.TagNumber(2)
  set attrTimeout($core.double value) => $_setDouble(1, value);
  @$pb.TagNumber(2)
  $core.bool hasAttrTimeout() => $_has(1);
  @$pb.TagNumber(2)
  void clearAttrTimeout() => $_clearField(2);
}

class ReadlinkReply extends $pb.GeneratedMessage {
  factory ReadlinkReply({
    $core.String? link,
  }) {
    final result = create();
    if (link != null) result.link = link;
    return result;
  }

  ReadlinkReply._();

  factory ReadlinkReply.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ReadlinkReply.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ReadlinkReply',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'bentos.fuse'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'link')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ReadlinkReply clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ReadlinkReply copyWith(void Function(ReadlinkReply) updates) =>
      super.copyWith((message) => updates(message as ReadlinkReply))
          as ReadlinkReply;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ReadlinkReply create() => ReadlinkReply._();
  @$core.override
  ReadlinkReply createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ReadlinkReply getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ReadlinkReply>(create);
  static ReadlinkReply? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get link => $_getSZ(0);
  @$pb.TagNumber(1)
  set link($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasLink() => $_has(0);
  @$pb.TagNumber(1)
  void clearLink() => $_clearField(1);
}

class StatfsReply extends $pb.GeneratedMessage {
  factory StatfsReply({
    $fixnum.Int64? blocks,
    $fixnum.Int64? bfree,
    $fixnum.Int64? bavail,
    $fixnum.Int64? files,
    $fixnum.Int64? ffree,
    $fixnum.Int64? bsize,
    $fixnum.Int64? namelen,
    $fixnum.Int64? frsize,
  }) {
    final result = create();
    if (blocks != null) result.blocks = blocks;
    if (bfree != null) result.bfree = bfree;
    if (bavail != null) result.bavail = bavail;
    if (files != null) result.files = files;
    if (ffree != null) result.ffree = ffree;
    if (bsize != null) result.bsize = bsize;
    if (namelen != null) result.namelen = namelen;
    if (frsize != null) result.frsize = frsize;
    return result;
  }

  StatfsReply._();

  factory StatfsReply.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory StatfsReply.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'StatfsReply',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'bentos.fuse'),
      createEmptyInstance: create)
    ..a<$fixnum.Int64>(1, _omitFieldNames ? '' : 'blocks', $pb.PbFieldType.OU6,
        defaultOrMaker: $fixnum.Int64.ZERO)
    ..a<$fixnum.Int64>(2, _omitFieldNames ? '' : 'bfree', $pb.PbFieldType.OU6,
        defaultOrMaker: $fixnum.Int64.ZERO)
    ..a<$fixnum.Int64>(3, _omitFieldNames ? '' : 'bavail', $pb.PbFieldType.OU6,
        defaultOrMaker: $fixnum.Int64.ZERO)
    ..a<$fixnum.Int64>(4, _omitFieldNames ? '' : 'files', $pb.PbFieldType.OU6,
        defaultOrMaker: $fixnum.Int64.ZERO)
    ..a<$fixnum.Int64>(5, _omitFieldNames ? '' : 'ffree', $pb.PbFieldType.OU6,
        defaultOrMaker: $fixnum.Int64.ZERO)
    ..a<$fixnum.Int64>(6, _omitFieldNames ? '' : 'bsize', $pb.PbFieldType.OU6,
        defaultOrMaker: $fixnum.Int64.ZERO)
    ..a<$fixnum.Int64>(7, _omitFieldNames ? '' : 'namelen', $pb.PbFieldType.OU6,
        defaultOrMaker: $fixnum.Int64.ZERO)
    ..a<$fixnum.Int64>(8, _omitFieldNames ? '' : 'frsize', $pb.PbFieldType.OU6,
        defaultOrMaker: $fixnum.Int64.ZERO)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  StatfsReply clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  StatfsReply copyWith(void Function(StatfsReply) updates) =>
      super.copyWith((message) => updates(message as StatfsReply))
          as StatfsReply;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static StatfsReply create() => StatfsReply._();
  @$core.override
  StatfsReply createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static StatfsReply getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<StatfsReply>(create);
  static StatfsReply? _defaultInstance;

  @$pb.TagNumber(1)
  $fixnum.Int64 get blocks => $_getI64(0);
  @$pb.TagNumber(1)
  set blocks($fixnum.Int64 value) => $_setInt64(0, value);
  @$pb.TagNumber(1)
  $core.bool hasBlocks() => $_has(0);
  @$pb.TagNumber(1)
  void clearBlocks() => $_clearField(1);

  @$pb.TagNumber(2)
  $fixnum.Int64 get bfree => $_getI64(1);
  @$pb.TagNumber(2)
  set bfree($fixnum.Int64 value) => $_setInt64(1, value);
  @$pb.TagNumber(2)
  $core.bool hasBfree() => $_has(1);
  @$pb.TagNumber(2)
  void clearBfree() => $_clearField(2);

  @$pb.TagNumber(3)
  $fixnum.Int64 get bavail => $_getI64(2);
  @$pb.TagNumber(3)
  set bavail($fixnum.Int64 value) => $_setInt64(2, value);
  @$pb.TagNumber(3)
  $core.bool hasBavail() => $_has(2);
  @$pb.TagNumber(3)
  void clearBavail() => $_clearField(3);

  @$pb.TagNumber(4)
  $fixnum.Int64 get files => $_getI64(3);
  @$pb.TagNumber(4)
  set files($fixnum.Int64 value) => $_setInt64(3, value);
  @$pb.TagNumber(4)
  $core.bool hasFiles() => $_has(3);
  @$pb.TagNumber(4)
  void clearFiles() => $_clearField(4);

  @$pb.TagNumber(5)
  $fixnum.Int64 get ffree => $_getI64(4);
  @$pb.TagNumber(5)
  set ffree($fixnum.Int64 value) => $_setInt64(4, value);
  @$pb.TagNumber(5)
  $core.bool hasFfree() => $_has(4);
  @$pb.TagNumber(5)
  void clearFfree() => $_clearField(5);

  @$pb.TagNumber(6)
  $fixnum.Int64 get bsize => $_getI64(5);
  @$pb.TagNumber(6)
  set bsize($fixnum.Int64 value) => $_setInt64(5, value);
  @$pb.TagNumber(6)
  $core.bool hasBsize() => $_has(5);
  @$pb.TagNumber(6)
  void clearBsize() => $_clearField(6);

  @$pb.TagNumber(7)
  $fixnum.Int64 get namelen => $_getI64(6);
  @$pb.TagNumber(7)
  set namelen($fixnum.Int64 value) => $_setInt64(6, value);
  @$pb.TagNumber(7)
  $core.bool hasNamelen() => $_has(6);
  @$pb.TagNumber(7)
  void clearNamelen() => $_clearField(7);

  @$pb.TagNumber(8)
  $fixnum.Int64 get frsize => $_getI64(7);
  @$pb.TagNumber(8)
  set frsize($fixnum.Int64 value) => $_setInt64(7, value);
  @$pb.TagNumber(8)
  $core.bool hasFrsize() => $_has(7);
  @$pb.TagNumber(8)
  void clearFrsize() => $_clearField(8);
}

class XattrReply extends $pb.GeneratedMessage {
  factory XattrReply({
    $fixnum.Int64? count,
    $core.List<$core.int>? data,
  }) {
    final result = create();
    if (count != null) result.count = count;
    if (data != null) result.data = data;
    return result;
  }

  XattrReply._();

  factory XattrReply.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory XattrReply.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'XattrReply',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'bentos.fuse'),
      createEmptyInstance: create)
    ..a<$fixnum.Int64>(1, _omitFieldNames ? '' : 'count', $pb.PbFieldType.OU6,
        defaultOrMaker: $fixnum.Int64.ZERO)
    ..a<$core.List<$core.int>>(
        2, _omitFieldNames ? '' : 'data', $pb.PbFieldType.OY)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  XattrReply clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  XattrReply copyWith(void Function(XattrReply) updates) =>
      super.copyWith((message) => updates(message as XattrReply)) as XattrReply;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static XattrReply create() => XattrReply._();
  @$core.override
  XattrReply createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static XattrReply getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<XattrReply>(create);
  static XattrReply? _defaultInstance;

  /// When getxattr/listxattr was called with size > 0, data holds the value.
  /// When called with size == 0, count holds the required buffer size.
  @$pb.TagNumber(1)
  $fixnum.Int64 get count => $_getI64(0);
  @$pb.TagNumber(1)
  set count($fixnum.Int64 value) => $_setInt64(0, value);
  @$pb.TagNumber(1)
  $core.bool hasCount() => $_has(0);
  @$pb.TagNumber(1)
  void clearCount() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.List<$core.int> get data => $_getN(1);
  @$pb.TagNumber(2)
  set data($core.List<$core.int> value) => $_setBytes(1, value);
  @$pb.TagNumber(2)
  $core.bool hasData() => $_has(1);
  @$pb.TagNumber(2)
  void clearData() => $_clearField(2);
}

class CreateReply extends $pb.GeneratedMessage {
  factory CreateReply({
    EntryReply? entry,
    OpenReply? openInfo,
  }) {
    final result = create();
    if (entry != null) result.entry = entry;
    if (openInfo != null) result.openInfo = openInfo;
    return result;
  }

  CreateReply._();

  factory CreateReply.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory CreateReply.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'CreateReply',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'bentos.fuse'),
      createEmptyInstance: create)
    ..aOM<EntryReply>(1, _omitFieldNames ? '' : 'entry',
        subBuilder: EntryReply.create)
    ..aOM<OpenReply>(2, _omitFieldNames ? '' : 'openInfo',
        subBuilder: OpenReply.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CreateReply clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CreateReply copyWith(void Function(CreateReply) updates) =>
      super.copyWith((message) => updates(message as CreateReply))
          as CreateReply;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static CreateReply create() => CreateReply._();
  @$core.override
  CreateReply createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static CreateReply getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<CreateReply>(create);
  static CreateReply? _defaultInstance;

  @$pb.TagNumber(1)
  EntryReply get entry => $_getN(0);
  @$pb.TagNumber(1)
  set entry(EntryReply value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasEntry() => $_has(0);
  @$pb.TagNumber(1)
  void clearEntry() => $_clearField(1);
  @$pb.TagNumber(1)
  EntryReply ensureEntry() => $_ensure(0);

  @$pb.TagNumber(2)
  OpenReply get openInfo => $_getN(1);
  @$pb.TagNumber(2)
  set openInfo(OpenReply value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasOpenInfo() => $_has(1);
  @$pb.TagNumber(2)
  void clearOpenInfo() => $_clearField(2);
  @$pb.TagNumber(2)
  OpenReply ensureOpenInfo() => $_ensure(1);
}

class LockReply extends $pb.GeneratedMessage {
  factory LockReply({
    FlockInfo? lock,
  }) {
    final result = create();
    if (lock != null) result.lock = lock;
    return result;
  }

  LockReply._();

  factory LockReply.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory LockReply.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'LockReply',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'bentos.fuse'),
      createEmptyInstance: create)
    ..aOM<FlockInfo>(1, _omitFieldNames ? '' : 'lock',
        subBuilder: FlockInfo.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  LockReply clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  LockReply copyWith(void Function(LockReply) updates) =>
      super.copyWith((message) => updates(message as LockReply)) as LockReply;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static LockReply create() => LockReply._();
  @$core.override
  LockReply createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static LockReply getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<LockReply>(create);
  static LockReply? _defaultInstance;

  @$pb.TagNumber(1)
  FlockInfo get lock => $_getN(0);
  @$pb.TagNumber(1)
  set lock(FlockInfo value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasLock() => $_has(0);
  @$pb.TagNumber(1)
  void clearLock() => $_clearField(1);
  @$pb.TagNumber(1)
  FlockInfo ensureLock() => $_ensure(0);
}

class BmapReply extends $pb.GeneratedMessage {
  factory BmapReply({
    $fixnum.Int64? idx,
  }) {
    final result = create();
    if (idx != null) result.idx = idx;
    return result;
  }

  BmapReply._();

  factory BmapReply.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory BmapReply.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'BmapReply',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'bentos.fuse'),
      createEmptyInstance: create)
    ..a<$fixnum.Int64>(1, _omitFieldNames ? '' : 'idx', $pb.PbFieldType.OU6,
        defaultOrMaker: $fixnum.Int64.ZERO)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  BmapReply clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  BmapReply copyWith(void Function(BmapReply) updates) =>
      super.copyWith((message) => updates(message as BmapReply)) as BmapReply;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static BmapReply create() => BmapReply._();
  @$core.override
  BmapReply createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static BmapReply getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<BmapReply>(create);
  static BmapReply? _defaultInstance;

  @$pb.TagNumber(1)
  $fixnum.Int64 get idx => $_getI64(0);
  @$pb.TagNumber(1)
  set idx($fixnum.Int64 value) => $_setInt64(0, value);
  @$pb.TagNumber(1)
  $core.bool hasIdx() => $_has(0);
  @$pb.TagNumber(1)
  void clearIdx() => $_clearField(1);
}

class LseekReply extends $pb.GeneratedMessage {
  factory LseekReply({
    $fixnum.Int64? offset,
  }) {
    final result = create();
    if (offset != null) result.offset = offset;
    return result;
  }

  LseekReply._();

  factory LseekReply.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory LseekReply.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'LseekReply',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'bentos.fuse'),
      createEmptyInstance: create)
    ..aInt64(1, _omitFieldNames ? '' : 'offset')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  LseekReply clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  LseekReply copyWith(void Function(LseekReply) updates) =>
      super.copyWith((message) => updates(message as LseekReply)) as LseekReply;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static LseekReply create() => LseekReply._();
  @$core.override
  LseekReply createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static LseekReply getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<LseekReply>(create);
  static LseekReply? _defaultInstance;

  @$pb.TagNumber(1)
  $fixnum.Int64 get offset => $_getI64(0);
  @$pb.TagNumber(1)
  set offset($fixnum.Int64 value) => $_setInt64(0, value);
  @$pb.TagNumber(1)
  $core.bool hasOffset() => $_has(0);
  @$pb.TagNumber(1)
  void clearOffset() => $_clearField(1);
}

class ReaddirReply extends $pb.GeneratedMessage {
  factory ReaddirReply({
    $core.Iterable<ReaddirEntry>? entries,
  }) {
    final result = create();
    if (entries != null) result.entries.addAll(entries);
    return result;
  }

  ReaddirReply._();

  factory ReaddirReply.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ReaddirReply.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ReaddirReply',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'bentos.fuse'),
      createEmptyInstance: create)
    ..pPM<ReaddirEntry>(1, _omitFieldNames ? '' : 'entries',
        subBuilder: ReaddirEntry.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ReaddirReply clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ReaddirReply copyWith(void Function(ReaddirReply) updates) =>
      super.copyWith((message) => updates(message as ReaddirReply))
          as ReaddirReply;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ReaddirReply create() => ReaddirReply._();
  @$core.override
  ReaddirReply createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ReaddirReply getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ReaddirReply>(create);
  static ReaddirReply? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<ReaddirEntry> get entries => $_getList(0);
}

class ReaddirEntry extends $pb.GeneratedMessage {
  factory ReaddirEntry({
    $core.String? name,
    $fixnum.Int64? ino,
    $core.int? mode,
    $fixnum.Int64? offset,
    StatAttr? attr,
    $core.double? attrTimeout,
    $core.double? entryTimeout,
  }) {
    final result = create();
    if (name != null) result.name = name;
    if (ino != null) result.ino = ino;
    if (mode != null) result.mode = mode;
    if (offset != null) result.offset = offset;
    if (attr != null) result.attr = attr;
    if (attrTimeout != null) result.attrTimeout = attrTimeout;
    if (entryTimeout != null) result.entryTimeout = entryTimeout;
    return result;
  }

  ReaddirEntry._();

  factory ReaddirEntry.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ReaddirEntry.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ReaddirEntry',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'bentos.fuse'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'name')
    ..a<$fixnum.Int64>(2, _omitFieldNames ? '' : 'ino', $pb.PbFieldType.OU6,
        defaultOrMaker: $fixnum.Int64.ZERO)
    ..aI(3, _omitFieldNames ? '' : 'mode', fieldType: $pb.PbFieldType.OU3)
    ..aInt64(4, _omitFieldNames ? '' : 'offset')
    ..aOM<StatAttr>(5, _omitFieldNames ? '' : 'attr',
        subBuilder: StatAttr.create)
    ..aD(6, _omitFieldNames ? '' : 'attrTimeout')
    ..aD(7, _omitFieldNames ? '' : 'entryTimeout')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ReaddirEntry clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ReaddirEntry copyWith(void Function(ReaddirEntry) updates) =>
      super.copyWith((message) => updates(message as ReaddirEntry))
          as ReaddirEntry;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ReaddirEntry create() => ReaddirEntry._();
  @$core.override
  ReaddirEntry createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ReaddirEntry getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ReaddirEntry>(create);
  static ReaddirEntry? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get name => $_getSZ(0);
  @$pb.TagNumber(1)
  set name($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasName() => $_has(0);
  @$pb.TagNumber(1)
  void clearName() => $_clearField(1);

  @$pb.TagNumber(2)
  $fixnum.Int64 get ino => $_getI64(1);
  @$pb.TagNumber(2)
  set ino($fixnum.Int64 value) => $_setInt64(1, value);
  @$pb.TagNumber(2)
  $core.bool hasIno() => $_has(1);
  @$pb.TagNumber(2)
  void clearIno() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.int get mode => $_getIZ(2);
  @$pb.TagNumber(3)
  set mode($core.int value) => $_setUnsignedInt32(2, value);
  @$pb.TagNumber(3)
  $core.bool hasMode() => $_has(2);
  @$pb.TagNumber(3)
  void clearMode() => $_clearField(3);

  @$pb.TagNumber(4)
  $fixnum.Int64 get offset => $_getI64(3);
  @$pb.TagNumber(4)
  set offset($fixnum.Int64 value) => $_setInt64(3, value);
  @$pb.TagNumber(4)
  $core.bool hasOffset() => $_has(3);
  @$pb.TagNumber(4)
  void clearOffset() => $_clearField(4);

  /// readdirplus: full entry_param
  @$pb.TagNumber(5)
  StatAttr get attr => $_getN(4);
  @$pb.TagNumber(5)
  set attr(StatAttr value) => $_setField(5, value);
  @$pb.TagNumber(5)
  $core.bool hasAttr() => $_has(4);
  @$pb.TagNumber(5)
  void clearAttr() => $_clearField(5);
  @$pb.TagNumber(5)
  StatAttr ensureAttr() => $_ensure(4);

  @$pb.TagNumber(6)
  $core.double get attrTimeout => $_getN(5);
  @$pb.TagNumber(6)
  set attrTimeout($core.double value) => $_setDouble(5, value);
  @$pb.TagNumber(6)
  $core.bool hasAttrTimeout() => $_has(5);
  @$pb.TagNumber(6)
  void clearAttrTimeout() => $_clearField(6);

  @$pb.TagNumber(7)
  $core.double get entryTimeout => $_getN(6);
  @$pb.TagNumber(7)
  set entryTimeout($core.double value) => $_setDouble(6, value);
  @$pb.TagNumber(7)
  $core.bool hasEntryTimeout() => $_has(6);
  @$pb.TagNumber(7)
  void clearEntryTimeout() => $_clearField(7);
}

/// Subset of struct stat fields needed for FUSE attr replies.
class StatAttr extends $pb.GeneratedMessage {
  factory StatAttr({
    $fixnum.Int64? ino,
    $fixnum.Int64? size,
    $fixnum.Int64? blocks,
    $fixnum.Int64? atime,
    $core.int? atimeNs,
    $fixnum.Int64? mtime,
    $core.int? mtimeNs,
    $fixnum.Int64? ctime,
    $core.int? ctimeNs,
    $core.int? mode,
    $core.int? nlink,
    $core.int? uid,
    $core.int? gid,
    $fixnum.Int64? rdev,
    $fixnum.Int64? blksize,
  }) {
    final result = create();
    if (ino != null) result.ino = ino;
    if (size != null) result.size = size;
    if (blocks != null) result.blocks = blocks;
    if (atime != null) result.atime = atime;
    if (atimeNs != null) result.atimeNs = atimeNs;
    if (mtime != null) result.mtime = mtime;
    if (mtimeNs != null) result.mtimeNs = mtimeNs;
    if (ctime != null) result.ctime = ctime;
    if (ctimeNs != null) result.ctimeNs = ctimeNs;
    if (mode != null) result.mode = mode;
    if (nlink != null) result.nlink = nlink;
    if (uid != null) result.uid = uid;
    if (gid != null) result.gid = gid;
    if (rdev != null) result.rdev = rdev;
    if (blksize != null) result.blksize = blksize;
    return result;
  }

  StatAttr._();

  factory StatAttr.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory StatAttr.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'StatAttr',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'bentos.fuse'),
      createEmptyInstance: create)
    ..a<$fixnum.Int64>(1, _omitFieldNames ? '' : 'ino', $pb.PbFieldType.OU6,
        defaultOrMaker: $fixnum.Int64.ZERO)
    ..a<$fixnum.Int64>(2, _omitFieldNames ? '' : 'size', $pb.PbFieldType.OU6,
        defaultOrMaker: $fixnum.Int64.ZERO)
    ..a<$fixnum.Int64>(3, _omitFieldNames ? '' : 'blocks', $pb.PbFieldType.OU6,
        defaultOrMaker: $fixnum.Int64.ZERO)
    ..aInt64(4, _omitFieldNames ? '' : 'atime')
    ..aI(5, _omitFieldNames ? '' : 'atimeNs', fieldType: $pb.PbFieldType.OU3)
    ..aInt64(6, _omitFieldNames ? '' : 'mtime')
    ..aI(7, _omitFieldNames ? '' : 'mtimeNs', fieldType: $pb.PbFieldType.OU3)
    ..aInt64(8, _omitFieldNames ? '' : 'ctime')
    ..aI(9, _omitFieldNames ? '' : 'ctimeNs', fieldType: $pb.PbFieldType.OU3)
    ..aI(10, _omitFieldNames ? '' : 'mode', fieldType: $pb.PbFieldType.OU3)
    ..aI(11, _omitFieldNames ? '' : 'nlink', fieldType: $pb.PbFieldType.OU3)
    ..aI(12, _omitFieldNames ? '' : 'uid', fieldType: $pb.PbFieldType.OU3)
    ..aI(13, _omitFieldNames ? '' : 'gid', fieldType: $pb.PbFieldType.OU3)
    ..a<$fixnum.Int64>(14, _omitFieldNames ? '' : 'rdev', $pb.PbFieldType.OU6,
        defaultOrMaker: $fixnum.Int64.ZERO)
    ..a<$fixnum.Int64>(
        15, _omitFieldNames ? '' : 'blksize', $pb.PbFieldType.OU6,
        defaultOrMaker: $fixnum.Int64.ZERO)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  StatAttr clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  StatAttr copyWith(void Function(StatAttr) updates) =>
      super.copyWith((message) => updates(message as StatAttr)) as StatAttr;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static StatAttr create() => StatAttr._();
  @$core.override
  StatAttr createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static StatAttr getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<StatAttr>(create);
  static StatAttr? _defaultInstance;

  @$pb.TagNumber(1)
  $fixnum.Int64 get ino => $_getI64(0);
  @$pb.TagNumber(1)
  set ino($fixnum.Int64 value) => $_setInt64(0, value);
  @$pb.TagNumber(1)
  $core.bool hasIno() => $_has(0);
  @$pb.TagNumber(1)
  void clearIno() => $_clearField(1);

  @$pb.TagNumber(2)
  $fixnum.Int64 get size => $_getI64(1);
  @$pb.TagNumber(2)
  set size($fixnum.Int64 value) => $_setInt64(1, value);
  @$pb.TagNumber(2)
  $core.bool hasSize() => $_has(1);
  @$pb.TagNumber(2)
  void clearSize() => $_clearField(2);

  @$pb.TagNumber(3)
  $fixnum.Int64 get blocks => $_getI64(2);
  @$pb.TagNumber(3)
  set blocks($fixnum.Int64 value) => $_setInt64(2, value);
  @$pb.TagNumber(3)
  $core.bool hasBlocks() => $_has(2);
  @$pb.TagNumber(3)
  void clearBlocks() => $_clearField(3);

  @$pb.TagNumber(4)
  $fixnum.Int64 get atime => $_getI64(3);
  @$pb.TagNumber(4)
  set atime($fixnum.Int64 value) => $_setInt64(3, value);
  @$pb.TagNumber(4)
  $core.bool hasAtime() => $_has(3);
  @$pb.TagNumber(4)
  void clearAtime() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.int get atimeNs => $_getIZ(4);
  @$pb.TagNumber(5)
  set atimeNs($core.int value) => $_setUnsignedInt32(4, value);
  @$pb.TagNumber(5)
  $core.bool hasAtimeNs() => $_has(4);
  @$pb.TagNumber(5)
  void clearAtimeNs() => $_clearField(5);

  @$pb.TagNumber(6)
  $fixnum.Int64 get mtime => $_getI64(5);
  @$pb.TagNumber(6)
  set mtime($fixnum.Int64 value) => $_setInt64(5, value);
  @$pb.TagNumber(6)
  $core.bool hasMtime() => $_has(5);
  @$pb.TagNumber(6)
  void clearMtime() => $_clearField(6);

  @$pb.TagNumber(7)
  $core.int get mtimeNs => $_getIZ(6);
  @$pb.TagNumber(7)
  set mtimeNs($core.int value) => $_setUnsignedInt32(6, value);
  @$pb.TagNumber(7)
  $core.bool hasMtimeNs() => $_has(6);
  @$pb.TagNumber(7)
  void clearMtimeNs() => $_clearField(7);

  @$pb.TagNumber(8)
  $fixnum.Int64 get ctime => $_getI64(7);
  @$pb.TagNumber(8)
  set ctime($fixnum.Int64 value) => $_setInt64(7, value);
  @$pb.TagNumber(8)
  $core.bool hasCtime() => $_has(7);
  @$pb.TagNumber(8)
  void clearCtime() => $_clearField(8);

  @$pb.TagNumber(9)
  $core.int get ctimeNs => $_getIZ(8);
  @$pb.TagNumber(9)
  set ctimeNs($core.int value) => $_setUnsignedInt32(8, value);
  @$pb.TagNumber(9)
  $core.bool hasCtimeNs() => $_has(8);
  @$pb.TagNumber(9)
  void clearCtimeNs() => $_clearField(9);

  @$pb.TagNumber(10)
  $core.int get mode => $_getIZ(9);
  @$pb.TagNumber(10)
  set mode($core.int value) => $_setUnsignedInt32(9, value);
  @$pb.TagNumber(10)
  $core.bool hasMode() => $_has(9);
  @$pb.TagNumber(10)
  void clearMode() => $_clearField(10);

  @$pb.TagNumber(11)
  $core.int get nlink => $_getIZ(10);
  @$pb.TagNumber(11)
  set nlink($core.int value) => $_setUnsignedInt32(10, value);
  @$pb.TagNumber(11)
  $core.bool hasNlink() => $_has(10);
  @$pb.TagNumber(11)
  void clearNlink() => $_clearField(11);

  @$pb.TagNumber(12)
  $core.int get uid => $_getIZ(11);
  @$pb.TagNumber(12)
  set uid($core.int value) => $_setUnsignedInt32(11, value);
  @$pb.TagNumber(12)
  $core.bool hasUid() => $_has(11);
  @$pb.TagNumber(12)
  void clearUid() => $_clearField(12);

  @$pb.TagNumber(13)
  $core.int get gid => $_getIZ(12);
  @$pb.TagNumber(13)
  set gid($core.int value) => $_setUnsignedInt32(12, value);
  @$pb.TagNumber(13)
  $core.bool hasGid() => $_has(12);
  @$pb.TagNumber(13)
  void clearGid() => $_clearField(13);

  @$pb.TagNumber(14)
  $fixnum.Int64 get rdev => $_getI64(13);
  @$pb.TagNumber(14)
  set rdev($fixnum.Int64 value) => $_setInt64(13, value);
  @$pb.TagNumber(14)
  $core.bool hasRdev() => $_has(13);
  @$pb.TagNumber(14)
  void clearRdev() => $_clearField(14);

  @$pb.TagNumber(15)
  $fixnum.Int64 get blksize => $_getI64(14);
  @$pb.TagNumber(15)
  set blksize($fixnum.Int64 value) => $_setInt64(14, value);
  @$pb.TagNumber(15)
  $core.bool hasBlksize() => $_has(14);
  @$pb.TagNumber(15)
  void clearBlksize() => $_clearField(15);
}

/// struct flock
class FlockInfo extends $pb.GeneratedMessage {
  factory FlockInfo({
    $core.int? type,
    $core.int? whence,
    $fixnum.Int64? start,
    $fixnum.Int64? len,
    $core.int? pid,
  }) {
    final result = create();
    if (type != null) result.type = type;
    if (whence != null) result.whence = whence;
    if (start != null) result.start = start;
    if (len != null) result.len = len;
    if (pid != null) result.pid = pid;
    return result;
  }

  FlockInfo._();

  factory FlockInfo.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory FlockInfo.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'FlockInfo',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'bentos.fuse'),
      createEmptyInstance: create)
    ..aI(1, _omitFieldNames ? '' : 'type')
    ..aI(2, _omitFieldNames ? '' : 'whence')
    ..aInt64(3, _omitFieldNames ? '' : 'start')
    ..aInt64(4, _omitFieldNames ? '' : 'len')
    ..aI(5, _omitFieldNames ? '' : 'pid')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  FlockInfo clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  FlockInfo copyWith(void Function(FlockInfo) updates) =>
      super.copyWith((message) => updates(message as FlockInfo)) as FlockInfo;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static FlockInfo create() => FlockInfo._();
  @$core.override
  FlockInfo createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static FlockInfo getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<FlockInfo>(create);
  static FlockInfo? _defaultInstance;

  @$pb.TagNumber(1)
  $core.int get type => $_getIZ(0);
  @$pb.TagNumber(1)
  set type($core.int value) => $_setSignedInt32(0, value);
  @$pb.TagNumber(1)
  $core.bool hasType() => $_has(0);
  @$pb.TagNumber(1)
  void clearType() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.int get whence => $_getIZ(1);
  @$pb.TagNumber(2)
  set whence($core.int value) => $_setSignedInt32(1, value);
  @$pb.TagNumber(2)
  $core.bool hasWhence() => $_has(1);
  @$pb.TagNumber(2)
  void clearWhence() => $_clearField(2);

  @$pb.TagNumber(3)
  $fixnum.Int64 get start => $_getI64(2);
  @$pb.TagNumber(3)
  set start($fixnum.Int64 value) => $_setInt64(2, value);
  @$pb.TagNumber(3)
  $core.bool hasStart() => $_has(2);
  @$pb.TagNumber(3)
  void clearStart() => $_clearField(3);

  @$pb.TagNumber(4)
  $fixnum.Int64 get len => $_getI64(3);
  @$pb.TagNumber(4)
  set len($fixnum.Int64 value) => $_setInt64(3, value);
  @$pb.TagNumber(4)
  $core.bool hasLen() => $_has(3);
  @$pb.TagNumber(4)
  void clearLen() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.int get pid => $_getIZ(4);
  @$pb.TagNumber(5)
  set pid($core.int value) => $_setSignedInt32(4, value);
  @$pb.TagNumber(5)
  $core.bool hasPid() => $_has(4);
  @$pb.TagNumber(5)
  void clearPid() => $_clearField(5);
}

const $core.bool _omitFieldNames =
    $core.bool.fromEnvironment('protobuf.omit_field_names');
const $core.bool _omitMessageNames =
    $core.bool.fromEnvironment('protobuf.omit_message_names');
