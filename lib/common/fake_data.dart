class HeroInfo {
  final String title;
  final String subtitle;
  final String image;

  HeroInfo({required this.title, required this.subtitle, required this.image});

  static final List<HeroInfo> items = [
    HeroInfo(
      title: "نواف ",
      subtitle: "   السلام عليكم  ",
      image: "assets/image1.png",
    ),
    HeroInfo(
      title: "محمد ",
      subtitle: "ان شاءالله",
      image: "assets/image2.png",
    ),
    HeroInfo(
      title: " خالد",
      subtitle: "يوم الجمعة وعدنا",
      image: "assets/image3.png",
    ),
    HeroInfo(
      title: " فيصل",
      subtitle: "جبلي معاك عشاء",
      image: "assets/image4.png",
    ),
    HeroInfo(
      title: "راكان",
      subtitle: "عليكم السلا هلا",
      image: "assets/image5.png",
    ),
    HeroInfo(
      title: "سعد ",
      subtitle: "خلصت الاسايمنت ولا باقي؟",
      image: "assets/image6.png",
    ),
    HeroInfo(
      title: " فهد",
      subtitle: " تمام يعطيك العافية",
      image: "assets/image7.png",
    ),
    HeroInfo(
      title: " عمر",
      subtitle: "وش صار على موضوعنا ",
      image: "assets/image8.png",
    ),
  ];
}
