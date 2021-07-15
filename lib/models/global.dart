import 'package:flutter/material.dart';

abstract class Global {
  static const Color blue = const Color(0xff4A64FE);

  static const List lights = [
    {
      'location': 'Kitchen',
      'name': 'E7',
      'status': true,
      'position': [0.09, 0.09],
      'tile': 1,
    },
    {
      'location': 'Kitchen',
      'name': 'E10',
      'status': true,
      'position': [0.06, -0.11],
      'tile': 1,
    },
    {
      'location': 'Kitchen',
      'name': ' NHÀ XE ',
      'status': false,
      'position': [-0.13, 0.0075],
      'tile': 6,
    },
    {
      'location': 'Entrance',
      'name': 'E1',
      'status': true,
      'position': [-0.09, 0.105],
      'tile': 2,
    },
    {
      'location': 'Kitchen',
      'name': 'E2',
      'status': true,
      'position': [0.08, 0.0075],
      'tile': 5,
    },
    {
      'location': 'Kitchen',
      'name': ' ĐƯỜNG NỘI BỘ',
      'status': true,
      'position': [-0.05, 0.07],
      'tile': 5,
    },
    {
      'location': 'Office 01',
      'name': 'E3',
      'status': true,
      'position': [0.08, -0.097],
      'tile': 5,
    },
    {
      'location': 'Entrance',
      'name': 'E4',
      'status': true,
      'position': [0.02, 0.105],
      'tile': 2,
    },
    {
      'location': 'Office 01',
      'name': 'E5',
      'status': true,
      'position': [0.02, -0.008],
      'tile': 2,
    },
    {
      'location': 'Meeting room 01',
      'name': 'E6',
      'status': true,
      'position': [0.02, -0.12],
      'tile': 2,
    },
    {
      'location': 'Office 01',
      'name': 'E8',
      'status': false,
      'position': [-0.025, -0.097],
      'tile': 6,
    },
    {
      'location': 'Kitchen',
      'name': 'E8B',
      'status': false,
      'position': [0.04, 0.0075],
      'tile': 6,
    },
    {
      'location': 'Kitchen',
      'name': 'CĂN TIN',
      'status': true,
      'position': [-0.005, 0.08],
      'tile': 6,
    },
    {
      'location': 'Office 02',
      'name': 'E9',
      'status': true,
      'position': [-0.1, -0.12],
      'tile': 3,
    },
    {
      'location': 'Office 02',
      'name': 'C1',
      'status': true,
      'position': [-0.05, -0.09],
      'tile': 8,
    },
    {
      'location': 'Office 02',
      'name': 'C2',
      'status': true,
      'position': [0.08, -0.02],
      'tile': 8,
    },
    {
      'location': 'Office 02',
      'name': 'C3',
      'status': true,
      'position': [-0.1, -0.09],
      'tile': 9,
    },
    {
      'location': 'Box Office',
      'name': ' ĐƯỜNG ĐI BỘ',
      'status': false,
      'position': [-0.05, -0.03],
      'tile': 4,
    },
    {
      'location': 'Entrance',
      'name': ' CỔNG TRƯỜNG',
      'status': false,
      'position': [-0.05, -0.04],
      'tile': 7,
    },
    {
      'location': 'Office 02',
      'name': '450 Lê Văn Việt',
      'status': true,
      'position': [0.03, 0.11],
      'tile': 8,
    },
  ];
  static const List dayNha = [
    {
      'name': 'E1',
      'position': [155.0, 170.0],
      'status': true,
      'image': '',
    },
    {
      'name': 'E2',
      'position': [190.0, 235.0],
      'status': true,
      'image': '',
    },
    {
      'name': 'E3',
      'position': [190.0, 190.0],
      'status': true,
      'image': '',
    },
    {
      'name': 'E4',
      'position': [190.0, 145.0],
      'status': true,
      'image': '',
    },
    {
      'name': 'E5',
      'position': [190.0, 104.0],
      'status': true,
      'image': '',
    },
    {
      'name': 'E6',
      'position': [190.0, 60.0],
      'status': false,
      'image': '',
    },
    {
      'name': 'E7',
      'position': [100.0, 140.0],
      'status': false,
      'image': '',
    },
    {
      'name': 'E8',
      'position': [290.0, 190.0],
      'status': true,
      'image': '',
    },
    {
      'name': 'E9',
      'position': [260.0, 60.0],
      'status': false,
      'image': '',
    },
    {
      'name': 'E10',
      'position': [80.0, 60.0],
      'status': true,
      'image': '',
    },
    {
      'name': 'C1',
      'position': [140.0, 320.0],
      'status': true,
      'image': '',
    },
    {
      'name': 'C2',
      'position': [210.0, 340.0],
      'status': true,
      'image': '',
    },
  ];
  static const List phongHoc = [
    {
      'name': '204E7',
      'position': [100.0, 140.0],
      'status': true,
      'image': 'image.png',
      'building': 'E7'
    },
    {
      'name': '204E7',
      'position': [200.0, 200.0],
      'status': true,
      'image': 'image.png',
      'building': 'E7'
    },
  ];
}
