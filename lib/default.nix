{ lib, ... }:

with lib; rec {

  # shorthand functions for making options
  mkOpt = type: default: description:
    mkOption { inherit type default description; };

  mkOpt' = type: default: mkOpt type default null;

  mkBoolOpt = mkOpt types.bool;

  mkBoolOpt' = mkOpt' types.bool;

  mkStrOpt = mkOpt types.str;

  mkStrOpt' = mkOpt' types.str;

  # applies value to each normal user in users
  forEachNormalUser = users: value:
    let acc = {}; in
    builtins.foldl'
      (acc: user: acc // { "${user}" = value; })
      acc
      (filter
        (e: e != "root" && users."${e}".isNormalUser == true)
        (mapAttrsToList (name: _: name) users));

  # source: https://stackoverflow.com/a/54505212
  recursiveMerge = attrList:
    let f = attrPath:
      zipAttrsWith (n: values:
        if tail values == []
          then head values
        else if all isList values
          then unique (concatLists values)
        else if all isAttrs values
          then f (attrPath ++ [n]) values
        else last values
      );
    in f [] attrList;

  # flattens an attribute set
  flattenAttrset = attrs:
      let acc = {}; in
      builtins.foldl'
        (acc: cur: recursiveMerge [acc attrs."${cur}"])
        acc
        (mapAttrsToList (name: _: name) attrs);
}
