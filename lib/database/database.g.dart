// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database.dart';

// **************************************************************************
// FloorGenerator
// **************************************************************************

abstract class $AppDatabaseBuilderContract {
  /// Adds migrations to the builder.
  $AppDatabaseBuilderContract addMigrations(List<Migration> migrations);

  /// Adds a database [Callback] to the builder.
  $AppDatabaseBuilderContract addCallback(Callback callback);

  /// Creates the database and initializes it.
  Future<AppDatabase> build();
}

// ignore: avoid_classes_with_only_static_members
class $FloorAppDatabase {
  /// Creates a database builder for a persistent database.
  /// Once a database is built, you should keep a reference to it and re-use it.
  static $AppDatabaseBuilderContract databaseBuilder(String name) =>
      _$AppDatabaseBuilder(name);

  /// Creates a database builder for an in memory database.
  /// Information stored in an in memory database disappears when the process is killed.
  /// Once a database is built, you should keep a reference to it and re-use it.
  static $AppDatabaseBuilderContract inMemoryDatabaseBuilder() =>
      _$AppDatabaseBuilder(null);
}

class _$AppDatabaseBuilder implements $AppDatabaseBuilderContract {
  _$AppDatabaseBuilder(this.name);

  final String? name;

  final List<Migration> _migrations = [];

  Callback? _callback;

  @override
  $AppDatabaseBuilderContract addMigrations(List<Migration> migrations) {
    _migrations.addAll(migrations);
    return this;
  }

  @override
  $AppDatabaseBuilderContract addCallback(Callback callback) {
    _callback = callback;
    return this;
  }

  @override
  Future<AppDatabase> build() async {
    final path = name != null
        ? await sqfliteDatabaseFactory.getDatabasePath(name!)
        : ':memory:';
    final database = _$AppDatabase();
    database.database = await database.open(
      path,
      _migrations,
      _callback,
    );
    return database;
  }
}

class _$AppDatabase extends AppDatabase {
  _$AppDatabase([StreamController<String>? listener]) {
    changeListener = listener ?? StreamController<String>.broadcast();
  }

  CarDao? _carDaoInstance;

  CarDealershipDao? _carDealershipDaoInstance;

  CustomerDao? _customerDaoInstance;

  SalesDao? _salesDaoInstance;

  Future<sqflite.Database> open(
    String path,
    List<Migration> migrations, [
    Callback? callback,
  ]) async {
    final databaseOptions = sqflite.OpenDatabaseOptions(
      version: 1,
      onConfigure: (database) async {
        await database.execute('PRAGMA foreign_keys = ON');
        await callback?.onConfigure?.call(database);
      },
      onOpen: (database) async {
        await callback?.onOpen?.call(database);
      },
      onUpgrade: (database, startVersion, endVersion) async {
        await MigrationAdapter.runMigrations(
            database, startVersion, endVersion, migrations);

        await callback?.onUpgrade?.call(database, startVersion, endVersion);
      },
      onCreate: (database, version) async {
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `Car` (`id` INTEGER NOT NULL, `brand` TEXT NOT NULL, `model` TEXT NOT NULL, `numberOfPassengers` INTEGER NOT NULL, `fuelType` TEXT NOT NULL, `fuelSize` REAL NOT NULL, PRIMARY KEY (`id`))');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `CarDealership` (`id` INTEGER NOT NULL, `name` TEXT NOT NULL, `streetAddress` TEXT NOT NULL, `city` TEXT NOT NULL, `zip` TEXT NOT NULL, PRIMARY KEY (`id`))');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `Customer` (`id` INTEGER NOT NULL, `firstName` TEXT NOT NULL, `lastName` TEXT NOT NULL, `address` TEXT NOT NULL, `birthday` TEXT NOT NULL, PRIMARY KEY (`id`))');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `Sales` (`id` INTEGER NOT NULL, `customerID` INTEGER NOT NULL, `carID` INTEGER NOT NULL, `carDealershipID` INTEGER NOT NULL, `dateOfPurchase` TEXT NOT NULL, PRIMARY KEY (`id`))');

        await callback?.onCreate?.call(database, version);
      },
    );
    return sqfliteDatabaseFactory.openDatabase(path, options: databaseOptions);
  }

  @override
  CarDao get carDao {
    return _carDaoInstance ??= _$CarDao(database, changeListener);
  }

  @override
  CarDealershipDao get carDealershipDao {
    return _carDealershipDaoInstance ??=
        _$CarDealershipDao(database, changeListener);
  }

  @override
  CustomerDao get customerDao {
    return _customerDaoInstance ??= _$CustomerDao(database, changeListener);
  }

  @override
  SalesDao get salesDao {
    return _salesDaoInstance ??= _$SalesDao(database, changeListener);
  }
}

class _$CarDao extends CarDao {
  _$CarDao(
    this.database,
    this.changeListener,
  )   : _queryAdapter = QueryAdapter(database),
        _carInsertionAdapter = InsertionAdapter(
            database,
            'Car',
            (Car item) => <String, Object?>{
                  'id': item.id,
                  'brand': item.brand,
                  'model': item.model,
                  'numberOfPassengers': item.numberOfPassengers,
                  'fuelType': item.fuelType,
                  'fuelSize': item.fuelSize
                }),
        _carUpdateAdapter = UpdateAdapter(
            database,
            'Car',
            ['id'],
            (Car item) => <String, Object?>{
                  'id': item.id,
                  'brand': item.brand,
                  'model': item.model,
                  'numberOfPassengers': item.numberOfPassengers,
                  'fuelType': item.fuelType,
                  'fuelSize': item.fuelSize
                }),
        _carDeletionAdapter = DeletionAdapter(
            database,
            'Car',
            ['id'],
            (Car item) => <String, Object?>{
                  'id': item.id,
                  'brand': item.brand,
                  'model': item.model,
                  'numberOfPassengers': item.numberOfPassengers,
                  'fuelType': item.fuelType,
                  'fuelSize': item.fuelSize
                });

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<Car> _carInsertionAdapter;

  final UpdateAdapter<Car> _carUpdateAdapter;

  final DeletionAdapter<Car> _carDeletionAdapter;

  @override
  Future<List<Car>> findAllCars() async {
    return _queryAdapter.queryList('SELECT * FROM Car',
        mapper: (Map<String, Object?> row) => Car(
            row['id'] as int,
            row['brand'] as String,
            row['model'] as String,
            row['numberOfPassengers'] as int,
            row['fuelType'] as String,
            row['fuelSize'] as double));
  }

  @override
  Future<void> deleteCarById(int id) async {
    await _queryAdapter
        .queryNoReturn('DELETE FROM Car WHERE id = ?1', arguments: [id]);
  }

  @override
  Future<void> clearAllCars() async {
    await _queryAdapter.queryNoReturn('DELETE FROM Car');
  }

  @override
  Future<void> insertCar(Car car) async {
    await _carInsertionAdapter.insert(car, OnConflictStrategy.abort);
  }

  @override
  Future<int> updateCar(Car car) {
    return _carUpdateAdapter.updateAndReturnChangedRows(
        car, OnConflictStrategy.abort);
  }

  @override
  Future<void> deleteCar(Car car) async {
    await _carDeletionAdapter.delete(car);
  }
}

class _$CarDealershipDao extends CarDealershipDao {
  _$CarDealershipDao(
    this.database,
    this.changeListener,
  )   : _queryAdapter = QueryAdapter(database),
        _carDealershipInsertionAdapter = InsertionAdapter(
            database,
            'CarDealership',
            (CarDealership item) => <String, Object?>{
                  'id': item.id,
                  'name': item.name,
                  'streetAddress': item.streetAddress,
                  'city': item.city,
                  'zip': item.zip
                }),
        _carDealershipUpdateAdapter = UpdateAdapter(
            database,
            'CarDealership',
            ['id'],
            (CarDealership item) => <String, Object?>{
                  'id': item.id,
                  'name': item.name,
                  'streetAddress': item.streetAddress,
                  'city': item.city,
                  'zip': item.zip
                }),
        _carDealershipDeletionAdapter = DeletionAdapter(
            database,
            'CarDealership',
            ['id'],
            (CarDealership item) => <String, Object?>{
                  'id': item.id,
                  'name': item.name,
                  'streetAddress': item.streetAddress,
                  'city': item.city,
                  'zip': item.zip
                });

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<CarDealership> _carDealershipInsertionAdapter;

  final UpdateAdapter<CarDealership> _carDealershipUpdateAdapter;

  final DeletionAdapter<CarDealership> _carDealershipDeletionAdapter;

  @override
  Future<List<CarDealership>> findAllCarDealerships() async {
    return _queryAdapter.queryList('SELECT * FROM CarDealership',
        mapper: (Map<String, Object?> row) => CarDealership(
            row['id'] as int,
            row['name'] as String,
            row['streetAddress'] as String,
            row['city'] as String,
            row['zip'] as String));
  }

  @override
  Future<void> deleteCarDealershipById(int id) async {
    await _queryAdapter.queryNoReturn('DELETE FROM CarDealership WHERE id = ?1',
        arguments: [id]);
  }

  @override
  Future<void> clearAllCarDealerships() async {
    await _queryAdapter.queryNoReturn('DELETE FROM CarDealership');
  }

  @override
  Future<void> insertCarDealership(CarDealership carDealership) async {
    await _carDealershipInsertionAdapter.insert(
        carDealership, OnConflictStrategy.abort);
  }

  @override
  Future<int> updateCarDealership(CarDealership carDealership) {
    return _carDealershipUpdateAdapter.updateAndReturnChangedRows(
        carDealership, OnConflictStrategy.abort);
  }

  @override
  Future<void> deleteCarDealership(CarDealership carDealership) async {
    await _carDealershipDeletionAdapter.delete(carDealership);
  }
}

class _$CustomerDao extends CustomerDao {
  _$CustomerDao(
    this.database,
    this.changeListener,
  )   : _queryAdapter = QueryAdapter(database),
        _customerInsertionAdapter = InsertionAdapter(
            database,
            'Customer',
            (Customer item) => <String, Object?>{
                  'id': item.id,
                  'firstName': item.firstName,
                  'lastName': item.lastName,
                  'address': item.address,
                  'birthday': item.birthday
                }),
        _customerUpdateAdapter = UpdateAdapter(
            database,
            'Customer',
            ['id'],
            (Customer item) => <String, Object?>{
                  'id': item.id,
                  'firstName': item.firstName,
                  'lastName': item.lastName,
                  'address': item.address,
                  'birthday': item.birthday
                }),
        _customerDeletionAdapter = DeletionAdapter(
            database,
            'Customer',
            ['id'],
            (Customer item) => <String, Object?>{
                  'id': item.id,
                  'firstName': item.firstName,
                  'lastName': item.lastName,
                  'address': item.address,
                  'birthday': item.birthday
                });

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<Customer> _customerInsertionAdapter;

  final UpdateAdapter<Customer> _customerUpdateAdapter;

  final DeletionAdapter<Customer> _customerDeletionAdapter;

  @override
  Future<List<Customer>> findAllCustomers() async {
    return _queryAdapter.queryList('SELECT * FROM Customer',
        mapper: (Map<String, Object?> row) => Customer(
            row['id'] as int,
            row['firstName'] as String,
            row['lastName'] as String,
            row['birthday'] as String,
            row['address'] as String));
  }

  @override
  Future<void> deleteCustomerById(int id) async {
    await _queryAdapter
        .queryNoReturn('DELETE FROM Customer WHERE id = ?1', arguments: [id]);
  }

  @override
  Future<void> clearAllCustomers() async {
    await _queryAdapter.queryNoReturn('DELETE FROM Customer');
  }

  @override
  Future<void> insertCustomer(Customer customer) async {
    await _customerInsertionAdapter.insert(customer, OnConflictStrategy.abort);
  }

  @override
  Future<void> updateCustomer(Customer customer) async {
    await _customerUpdateAdapter.update(customer, OnConflictStrategy.abort);
  }

  @override
  Future<void> deleteCustomer(Customer customer) async {
    await _customerDeletionAdapter.delete(customer);
  }
}

class _$SalesDao extends SalesDao {
  _$SalesDao(
    this.database,
    this.changeListener,
  )   : _queryAdapter = QueryAdapter(database),
        _salesInsertionAdapter = InsertionAdapter(
            database,
            'Sales',
            (Sales item) => <String, Object?>{
                  'id': item.id,
                  'customerID': item.customerID,
                  'carID': item.carID,
                  'carDealershipID': item.carDealershipID,
                  'dateOfPurchase': item.dateOfPurchase
                }),
        _salesUpdateAdapter = UpdateAdapter(
            database,
            'Sales',
            ['id'],
            (Sales item) => <String, Object?>{
                  'id': item.id,
                  'customerID': item.customerID,
                  'carID': item.carID,
                  'carDealershipID': item.carDealershipID,
                  'dateOfPurchase': item.dateOfPurchase
                }),
        _salesDeletionAdapter = DeletionAdapter(
            database,
            'Sales',
            ['id'],
            (Sales item) => <String, Object?>{
                  'id': item.id,
                  'customerID': item.customerID,
                  'carID': item.carID,
                  'carDealershipID': item.carDealershipID,
                  'dateOfPurchase': item.dateOfPurchase
                });

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<Sales> _salesInsertionAdapter;

  final UpdateAdapter<Sales> _salesUpdateAdapter;

  final DeletionAdapter<Sales> _salesDeletionAdapter;

  @override
  Future<List<Sales>> findAllSales() async {
    return _queryAdapter.queryList('SELECT * FROM Sales',
        mapper: (Map<String, Object?> row) => Sales(
            row['id'] as int,
            row['customerID'] as int,
            row['carID'] as int,
            row['carDealershipID'] as int,
            row['dateOfPurchase'] as String));
  }

  @override
  Future<void> deleteSalesById(int id) async {
    await _queryAdapter
        .queryNoReturn('DELETE FROM Sales WHERE id = ?1', arguments: [id]);
  }

  @override
  Future<void> clearAllSales() async {
    await _queryAdapter.queryNoReturn('DELETE FROM Car');
  }

  @override
  Future<void> insertSales(Sales sales) async {
    await _salesInsertionAdapter.insert(sales, OnConflictStrategy.abort);
  }

  @override
  Future<int> updateSales(Sales sales) {
    return _salesUpdateAdapter.updateAndReturnChangedRows(
        sales, OnConflictStrategy.abort);
  }

  @override
  Future<void> deleteSales(Sales sales) async {
    await _salesDeletionAdapter.delete(sales);
  }
}
