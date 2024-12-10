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
];

List<String> getVideoUrls() {
  return videoIds.map((id) => "$videoBaseUrl$id").toList();
}
