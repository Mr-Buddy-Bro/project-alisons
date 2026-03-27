import 'package:project_alisons/core/network/api_constants.dart';

class BannerModel {
  final int id;
  final String image;
  final String mobileImage;
  final String title;
  final String subTitle;
  final String buttonText;
  final String linkValue;

  BannerModel({
    required this.id,
    required this.image,
    required this.mobileImage,
    required this.title,
    required this.subTitle,
    required this.buttonText,
    required this.linkValue,
  });

  factory BannerModel.fromJson(Map<String, dynamic> json) {
    return BannerModel(
      id: json['id'] as int? ?? 0,
      image: ApiConstants.bannerImageUrl(json['image']?.toString() ?? ''),
      mobileImage:
          ApiConstants.bannerImageUrl(json['mobile_image']?.toString() ?? ''),
      title: json['title']?.toString() ?? '',
      subTitle: json['sub_title']?.toString() ?? '',
      buttonText: json['button_text']?.toString() ?? '',
      linkValue: json['link_value']?.toString() ?? '#',
    );
  }
}
