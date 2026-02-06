 <?php


const POOL = 0;
const HEAD = 1;
const SIDE = 2;
const FREE = 3;
const TOP  = 4;
const START = 5;
const RESERVED = 8;

class NxVm
{
  function __construct(
    $pool = 3,
    $head = 2
  ) {
    if ($pool < 0) {
      $side -1;
      $pool = -$pool;
      if ($head < 0)
        $head = -$head;
    } else {
      $side = 1;
      $head = -$head;
    }

    if ($pool < 3)
      $pool = 3;
    if ($pool - $head < 1)
      $head = 2;

    $res = ceil(RESERVED / $pool) * $pool;

    if ($side > 0) {
      $pool_ = 0;
      $head_ = HEAD;
      $free_ = FREE;
      $side_ = SIDE;
      $srt_ = START;
      $top_  = TOP;
    } else {
      $pool_ = '-0';
      $head_ = -HEAD;
      $free_ = -FREE;
      $top_  = -TOP;
      $side_ = -SIDE;
      $srt_ = -START;
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

  function getMeta(
    $side = true
  ) {
    $alt = $side == true ? -SIDE : SIDE;
    $side = $side == true ? SIDE : -SIDE;
    if (is_null($this->s[$side]))
      $side = $alt;
    print "\nSide: " . $this->s[$side];
    print "\nPool: " . $this->s[$side > 0 ? 0 : '-0'];
    print "\nHead: " . $this->s[HEAD * $side];
    print "\nFree Blocks: " . (empty($this->s[FREE * $side]) ? 'true' : 'false');
   // print "\nTop: " . $this->s[TOP * $side];
    //print "\nStart: " . $this->s[START * $side];
    //print "\nReserved: " . $this->s[RESERVED * $side];
  }
}

$inst = new NxVm();
$inst->getMeta();
?>
 
