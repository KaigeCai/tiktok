const String videoBaseUrl = "https://douyin.com/aweme/v1/play/?video_id=";

const List<String> videoIds = [
  "v0200fg10000cnfeervog65p4oejdh0g",
  "v0200fg10000cjdkiajc77u5fm11ptm0",
  "v0200fg10000cjpihrjc77u3gdldcmrg",
  "v0200fg10000cjrg5orc77u1f1n1u7o0",
  "v1e00fgi0000ct63rfnog65npgk9n1fg",
  "v0200fa40000boul940nrm1hl30b2f3g",
  "v0200fg10000ct1a10fog65o28em7cpg",
  "v1e00fgi0000ct0t5dfog65q2oek2hbg",
  "v1e00fgi0000ct3neu7og65t6du0fdh0",
  "v0200fg10000cnesndvog65p4oe49beg",
  "v0d00fg10000crsk5dnog65sckr89ud0",
  "v0d00fg10000crr5skfog65qa1gd900g",
  "v0300fg10000cikmknbc77u17226t7cg",
  "v0d00fg10000crpc7a7og65klre9ebd0",
  "v0d00fg10000cjeog8bc77u5q8b9eaqg",
  "v0200fg10000com7hn3c77ue08sv7ep0",
  "v0200fg10000cpeo1lfog65niecn74k0",
  "v0d00fg10000cptvhdfog65kr3nil9a0",
  "v0200fg10000cnm02r7og65iciqgb4t0",
  "v0300fg10000ct6l2c7og65i0hh52g30",
  "v0300fg10000ct5fppfog65l8he7nssg",
  "v0300fg10000ct6lr9vog65lvt9be22g",
  "v0300fg10000cshdp47og65ldp075eo0",
  "v0300fg10000cq08lsvog65o4mfdabug",
  "v0300fg10000cps16qnog65vs5qd7qjg",
  "v0200fg10000cngok0nog65odiqqgdi0",
  "v0200f560000bl4rm06vld7b7ai0rg00",
  "v0d00fg10000ct67pfnog65k0elnm31g",
  "v0200f440000bgtc391pskdod95v5fng",
  "v0200f770000bfns1gjivfcoe936rhug",
  "v0300fd10000bejlh5sqn5hc7na55va0",
  "v0200f960000bfqjdfg9lr71ofk6aho0",
  "v0200fg10000csjjdhfog65jgae7f8e0",
  "v0d00fg10000csvam6vog65u5r2pmmig",
  "v0300f9a0000bvffp1kv9nu4ugivuuug",
  "v0200fg10000cf37msjc77u007983s9g",
  "v0300fg10000ct9d3b7og65pd2a20tn0",
  "643642a1d34a468da6447c92a58f8b5e",
  "v0200fg10000cga37cjc77ufm9fhdtqg",
  "v0d00fg10000cgo1hsrc77u6krr2d47g",
  "v0d00fg10000cr1j8cvog65jtm438ap0",
  "v0d00fg10000cob6fubc77u8vc67b960",
  "v0300fg10000cm9clvvog65qj97gpfi0",
  "v0200fg10000cei5pkrc77u017c5odpg",
  "v0d00fg10000ch4hhgjc77u72deo4uag",
  "v0200fg10000cs17nsnog65gn8toqifg",
  "v0200fg10000cjdkl63c77ud185o0ad0",
  "v0300fg10000ct0vpjvog65tmduphbmg",
  "v0200fg10000ctaehkfog65n9lurjha0",
  "v1e00fgi0000ct440ovog65u4mm91nc0",
  "v1e00fgi0000ct6obs7og65g8tdakjg0",
  "v0200fg10000ct656gfog65mkpskn940",
  "v0300fg10000ct6543nog65sk0uvgdpg",
  "v0200fg10000ct5qr2nog65o1hb8hhcg",
  "v0d00fg10000cslg36vog65o5pgndumg",
  "v0200fg10000csri60vog65unh722nmg",
  "v0200fg10000csvanbvog65pkgdpd0b0",
  "v0200fg10000cr6ob0fog65vmvfb2ip0",
  "v0200fg10000crr695nog65tb1sl4ahg",
];

List<String> getVideoUrls() {
  return videoIds.map((id) => "$videoBaseUrl$id").toList();
}
