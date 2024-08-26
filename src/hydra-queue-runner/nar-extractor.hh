#pragma once

#include "fs-accessor.hh"
#include "types.hh"
#include "serialise.hh"
#include "hash.hh"

struct NarMemberData
{
    nix::FSAccessor::Type type;
    std::optional<uint64_t> fileSize;
    std::optional<std::string> contents;
    std::optional<nix::Hash> sha256;
};

using NarMemberDatas = std::map<nix::Path, NarMemberData>;

/* Read a NAR from a source and get to some info about every file
   inside the NAR. */
void extractNarData(
    nix::Source & source,
    const nix::Path & prefix,
    NarMemberDatas & members);

nix::WireFormatGenerator extractNarDataFilter(
    nix::Source & source,
    const nix::Path & prefix,
    NarMemberDatas & members);
