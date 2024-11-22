// required package imports
import 'dart:async';
import 'package:floor/floor.dart';
import 'package:sqflite/sqflite.dart' as sqflite;

import 'package:final_project/dao/car_dao.dart';
import 'package:final_project/dao/car_dealership_dao.dart';
import 'package:final_project/dao/customer_dao.dart';
import 'package:final_project/dao/sales_dao.dart';

import 'package:final_project/entity/car.dart';
import 'package:final_project/entity/car_dealership.dart';
import 'package:final_project/entity/customer.dart';
import 'package:final_project/entity/sales.dart';


part 'database.g.dart';

@Database(version: 1, entities: [Car, CarDealership, Customer, Sales])
abstract class AppDatabase extends FloorDatabase {
  CarDao get carDao;
  CarDealershipDao get carDealershipDao;
  CustomerDao get customerDao;
  SalesDao get salesDao;
}


