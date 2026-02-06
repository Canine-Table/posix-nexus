🐶
canine_table
Invisible

🐶

 — 11/25/25, 11:14 AM
 # Create VLAN SVI interfaces on the bridge for routing
ip link add link bridge0 name bridge0.144 type vlan id 144
ip addr add 172.16.144.1/20 dev bridge0.144
ip link set bridge0.144 up

# Repeat for each VLAN
ip link add link bridge0 name bridge0.160 type vlan id 160
ip addr add 172.16.160.1/20 dev bridge0.160
ip link set bridge0.160 up
# ... and so on for 176, 192, 208, 224, 240, 999 (as needed)
 
🐶

 — 11/25/25, 11:35 AM
 # Create bond in active-backup mode
modprobe bonding
ip link add bond0 type bond mode active-backup

# Add slaves
ip link set eth0 master bond0
ip link set wlan0 master bond0

# Bring slaves up (no IPs, no DHCP)
ip addr flush dev eth0
ip addr flush dev wlan0
ip link set eth0 up
ip link set wlan0 up

# Bring bond up
ip link set bond0 up

# Assign IP to bond (static example)
ip addr add 172.16.128.10/17 dev bond0

# Or run DHCP client only on bond
dhclient bond0
 
🐶

 — 11/26/25, 7:08 AM
https://m.youtube.com/watch?v=3a-X6FZfl2Y
YouTube
Dammit Jeff
Jailbreaking Calculators Is (Unfortunately) a Thing Now
Image
🐶

 — 11/30/25, 12:18 PM
tex.texcatcodes
🐶

 — 12/12/25, 3:21 PM
Image
🐶

 — 12/14/25, 2:19 PM
 function int_to_rgb(n):
    assert 0 <= n < 16777216
    R = floor(n / 65536)            # 65536 = 256*256
    remainder = n % 65536
    G = floor(remainder / 256)
    B = remainder % 256
    return (R, G, B)
 
function rgb_to_int(R, G, B):
    assert 0 <= R < 256 and 0 <= G < 256 and 0 <= B < 256
    return R * 65536 + G * 256 + B
https://gist.github.com/fnky/458719343aabd01cfb17a3a4f7296797
Gist
ANSI Escape Codes
ANSI Escape Codes. GitHub Gist: instantly share code, notes, and snippets.
ANSI Escape Codes
🐶

 — 12/16/25, 12:33 AM
 You can choose layout (row-major vs column-major, interleaved vs planar) to make the most-used dimension unit-stride. 
🐶

 — 12/31/25, 12:51 AM
 // Source - https://stackoverflow.com/a
// Posted by Yuval Adam, modified by community. See post 'Timeline' for change history
// Retrieved 2025-12-31, License - CC BY-SA 3.0

typedef int (*myFuncDef)(int, int);
// note that the typedef name is indeed myFuncDef

myFuncDef functionFactory(int n) {
    printf("Got parameter %d", n);
    myFuncDef functionPtr = &addInt;
    return functionPtr;
}
 // Source - https://stackoverflow.com/a
// Posted by coobird, modified by community. See post 'Timeline' for change history
// Retrieved 2025-12-31, License - CC BY-SA 3.0

String newString()
{
    String self = (String)malloc(sizeof(struct String_Struct));

    self->get = &getString;
    self->set = &setString;
    self->length = &lengthString;

    self->set(self, "");

    return self;
}
 
 // Source - https://stackoverflow.com/a
// Posted by coobird, modified by community. See post 'Timeline' for change history
// Retrieved 2025-12-31, License - CC BY-SA 3.0

char* getString(const void* self_obj)
{
    return ((String)self_obj)->internal->value;
}
 
🐶

 — 12/31/25, 12:59 AM
 // Source - https://stackoverflow.com/a
// Posted by coobird, modified by community. See post 'Timeline' for change history
// Retrieved 2025-12-31, License - CC BY-SA 3.0

ImmutableString newImmutableString(const char* value)
{
    ImmutableString self = (ImmutableString)malloc(sizeof(struct ImmutableString_Struct));

    self->base = newString();

    self->get = self->base->get;
    self->length = self->base->length;

    self->base->set(self->base, (char*)value);

    return self;
}
 
🐶

 — 12/31/25, 1:14 AM
 // Source - https://stackoverflow.com/a
// Posted by Richard Chambers
// Retrieved 2025-12-31, License - CC BY-SA 4.0

int (*pFunc) (int a, char *pStr);    // declare a simple function pointer variable
int (*pFunc[55])(int a, char *pStr); // declare an array of 55 function pointers
int (**pFunc)(int a, char *pStr);    // declare a pointer to a function pointer variable
struct {                             // declare a struct that contains a function pointer
    int x22;
    int (*pFunc)(int a, char *pStr);
} thing = {0, func};                 // assign values to the struct variable
char * xF (int x, int (*p)(int a, char *pStr));  // declare a function that has a function pointer as an argument
char * (*pxF) (int x, int (*p)(int a, char *pStr));  // declare a function pointer that points to a function that has a function pointer as an argument
 
🐶

 — 1/2/26, 11:18 AM
 It resembles a slab allocator or buddy system hybrid, optimized for low overhead and fast access in constrained environments. 
🐶

 — 1/18/26, 11:17 PM
 fio --name=randread --filename=/dev/zvol/pool/vm01 --ioengine=libaio --direct=1 \
    --rw=randread --bs=4k --size=4G --numjobs=4 --runtime=60 --time_based \
    --group_reporting

fio --name=randwrite --filename=/dev/zvol/pool/vm01 --ioengine=libaio --direct=1 \
    --rw=randwrite --bs=4k --size=4G --numjobs=4 --runtime=60 --time_based \
    --group_reporting

fio --name=seqwrite --filename=/dev/zvol/pool/vm01 --ioengine=libaio --direct=1 \
    --rw=write --bs=32k --size=4G --numjobs=1 --runtime=60 --time_based \
    --group_reporting
🐶

 — 1/19/26, 11:24 AM
Image
🐶

 — 1/22/26, 10:51 AM
Image
🐶

 — 1/22/26, 11:06 PM
Image
Image
🐶

 — 1/24/26, 1:30 PM
unsigned char nx_ubyte_add_HBB(nx_u16 *r, unsigned char a, unsigned char b)
{
        unsigned short s = nx_ubyte_get_BB(a, b);
        r->h = (unsigned char)(s - UCHAR_MAX);
        r->l = (unsigned char)(s) - r->h;
        return r->h;
}

unsigned short nx_ubyte_get_BB(unsigned char a, unsigned char b)
{
        return (unsigned short)a + (unsigned short)b;
}

unsigned short nx_u16_get_H(nx_u16 *r)
{
        return nx_ubyte_get_BB(r->l, r->h);
}
🐶

 — 1/24/26, 6:19 PM
db → 1 byte
• dw → 2 bytes
• dd → 4 bytes
• da → 8 bytes
• do → 16 bytes
• dh → 32 bytes
• ds → 64 bytes
• dp → 128 bytes
• dx → 256 bytes
• d2 → 512 bytes d3 → 1024 bytes
Image
🐶

 — 1/27/26, 2:23 PM
 layerTable[id] = {
    bbox: { x, y, w, h },
    drawables: [...],
    entities: Set(...),
    visible: true,
    mode: "normal",
    ...
}
🐶

 — 1/28/26, 10:23 AM
 edk2-ovmf nvidia-settings swtpm opencl-nvidia ocl-icd glxinfo fio vulkaninfo vulkan-tools cuda cudnn tensorflow pytorch glxinfo vulkaninfo thermald vulkan-tools mesa mesa-vdpau vulkan-icd-loader vulkan-headers lib32-nvidia-utils mesa-vdpau vdpauinfo vulkan-tools 
 sudo pacman -S edk2-ovmf nvidia nvidia-utils lib32-nvidia-utils vulkan-icd-loader vulkan-tools vulkan-headers mesa fio thermald mesa-demos 
🐶

 — 1/28/26, 12:24 PM
 (
SynthDef(\sfxFractal, {
    |freq = 440, amp = 0.1, dur = 0.5|
    var env = EnvGen.kr(Env.perc(0.01, dur), doneAction: 2);
    var sig = SinOsc.ar(freq, 0, amp) * env;
    Out.ar(0, sig.dup);
}).add;

Routine({
    var c = Complex(0.355, 0.355); // seed value
    var z, iter, maxIter = 64;
    var freq, amp;

    inf.do {
        z = Complex(0.0, 0.0);
        iter = 0;
        while {
            iter < maxIter and: { z.abs < 2.0 }
        } {
            z = z * z * z - (c * c);
            iter = iter + 1;
        };

        freq = iter.linexp(1, maxIter, 200, 1200); // map iteration to frequency
        amp = iter.linlin(1, maxIter, 0.05, 0.2);  // map iteration to amplitude

        Synth(\sfxFractal, [\freq, freq, \amp, amp, \dur, 0.2]);
        0.2.wait;
    };
}).play;
)
🐶

 — 1/28/26, 4:17 PM
 const leftList = [1, 2, 3, 4];
const rightList = [2, 4];
const rightSet = new Set(rightList);

const result = leftList.filter(item => !rightSet.has(item));
console.log(result); // Output: [1, 3]    
🐶

 — 1/29/26, 9:54 PM
Image
Image
🐶

 — 2/4/26, 10:06 PM
``` function throttle(fn, limit) {
  let waiting = false;
  return (...args) => {
    if (!waiting) {
      fn.apply(this, args);
      waiting = true;
      setTimeout(() => waiting = false, limit);
    }
  };
}   function debounce(fn, delay) {
  let timer;
  return (...args) => {
    clearTimeout(timer);
    timer = setTimeout(() => fn.apply(this, args), delay);
  };
}
🐶

 — 3:37 PM
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

