// Required package imports for database setup
import 'dart:async'; // Provides asynchronous programming utilities
import 'package:floor/floor.dart'; // Floor package for SQLite database interaction
import 'package:sqflite/sqflite.dart' as sqflite; // Sqflite package for low-level database access

// Importing DAOs (Data Access Objects) for interacting with database entities
import 'package:final_project/dao/car_dao.dart'; // DAO for the `Car` entity
import 'package:final_project/dao/car_dealership_dao.dart'; // DAO for the `CarDealership` entity
import 'package:final_project/dao/customer_dao.dart'; // DAO for the `Customer` entity
import 'package:final_project/dao/sales_dao.dart'; // DAO for the `Sales` entity

// Importing entity classes that represent the structure of the database tables
import 'package:final_project/entity/car.dart'; // `Car` entity class
import 'package:final_project/entity/car_dealership.dart'; // `CarDealership` entity class
import 'package:final_project/entity/customer.dart'; // `Customer` entity class
import 'package:final_project/entity/sales.dart'; // `Sales` entity class

part 'database.g.dart';

/// The main application database class.
@Database(version: 1, entities: [Car, CarDealership, Customer, Sales]) // Specifies database version and entities
abstract class AppDatabase extends FloorDatabase {
  // Accessor methods for the DAOs
  CarDao get carDao; // Accessor for the `Car` DAO
  CarDealershipDao get carDealershipDao; // Accessor for the `CarDealership` DAO
  CustomerDao get customerDao; // Accessor for the `Customer` DAO
  SalesDao get salesDao; // Accessor for the `Sales` DAO
}
