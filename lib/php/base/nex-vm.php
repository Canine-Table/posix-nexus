<?php 

class NxVm
{
  const POOL = 0;
  const HEAD = 1;

nex-vm.php
3 KB
﻿
Canine
canine9815
<?php 

class NxVm
{
  const POOL = 0;
  const HEAD = 1;
  const SIDE = 2;
  const FREE = 3;
  const TOP  = 4;
  const START = 5;
  const RESERVED = 8;

  function __construct(
    $pool = 3,
    $head = 2
  ) {
    $side = 1;
    if ($pool < 0) {
      $side -1;
      $pool = -$pool;
      if ($head < 0)
        $head = -$head;
    } else if ($head < 0) {
      $head = -$head;
    }

    if ($pool < 3)
      $pool = 3;
    if ($pool - $head < 1)
      $head = 2;

    $res = ceil($this::RESERVED / $pool) * $pool;

    if ($side > 0) {
      $pool_ = 0;
      $head_ = $this::HEAD;
      $free_ = $this::FREE;
      $side_ = $this::SIDE;
      $srt_ = $this::START;
      $top_  = $this::TOP;
    } else {
      $pool_ = '-0';
      $head_ = -$this::HEAD;
      $free_ = -$this::FREE;
      $top_  = -$this::TOP;
      $side_ = -$this::SIDE;
      $srt_ = -$this::START;
      $res   = -$res_;
      $head  = -$head;
      $pool  = -$pool;
    }

    $this->s[$pool_] = $pool;
    $this->s[$head_] = $head;
    $this->s[$side_] = $side;
    $this->s[$free_] = 0;
    $this->s[$top_] = $res;
    $this->s[$srt_] = $res;
    $this->s[$res] = 0;
    $this->s[$res + $side] = $res + $head;
  }

  function getSide(
    $side = true
  ) {
    return ($side === true
      ? $this->s[-$this::SIDE] ?? null
      : $this->s[$this::SIDE] ?? null
    ) ?? $this->s[(
      $side === true
        ? $this::SIDE
        : -$this::SIDE
    )] ?? null;
  }

  function getMeta(
    $side = true
  ) {
    $alt = $this->getSide(false);
    $side = $this->getSide(true);

    if (is_null($side)) {
      if (is_null($alt))
        return null;
      $side = $alt;
    }

    $top = $this->s[$this::TOP * $side];
    print "\nSide: " . $side;
    print "\nPool: " . $this->s[$side > 0 ? 0 : '-0'];
    print "\nHead: " . $this->s[$this::HEAD * $side];
    print "\nStart: " . $this->s[$this::START * $side];
    print "\nTop: " . $this->s[$this::TOP * $side];
    print "\nTop Head: " . $this->s[$top + $side];
    print "\nReserved: " . $this::RESERVED * $side;
    print "\nFree Blocks: " . (is_null($this->s[$this::FREE * $side]) ? 'true' : 'false');
    print "\n";
  }
}

