import 'package:expense_tracker/features/add_transaction/data_layer/data_source/transaction_data_source.dart';
import 'package:expense_tracker/features/add_transaction/data_layer/repository/transaction_repository_impl.dart';
import 'package:expense_tracker/features/add_transaction/domain_layer/use_case/add_transaction_use_case.dart';
import 'package:expense_tracker/features/add_transaction/domain_layer/use_case/call_transaction_use_case.dart';
import 'package:expense_tracker/features/add_transaction/domain_layer/use_case/delete_transaction_use_case.dart';
import 'package:expense_tracker/features/add_transaction/domain_layer/use_case/update_transaction_use_case.dart';
import 'package:expense_tracker/features/add_transaction/presentation/bloc/add_income_expense_bloc.dart';
import 'package:expense_tracker/features/auth/data_layer/data_source/sign_up_local_data_source.dart';
import 'package:expense_tracker/features/auth/data_layer/repository_impl/sign_up_repo_impl.dart';
import 'package:expense_tracker/features/auth/domain_layer/repositories/sign_up_repositories.dart';
import 'package:expense_tracker/features/auth/domain_layer/use_cases/get_user_use_case.dart';
import 'package:expense_tracker/features/auth/domain_layer/use_cases/profile_update_use_case.dart';
import 'package:expense_tracker/features/auth/domain_layer/use_cases/sign_up_use_case.dart';
import 'package:expense_tracker/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:expense_tracker/features/bottom_navigation/bloc/navigation_bloc.dart';
import 'package:expense_tracker/features/category/data_layer/data_source/category_data_source.dart';
import 'package:expense_tracker/features/category/data_layer/repository/category_repository_impl.dart';
import 'package:expense_tracker/features/category/domain_layer/repositories/category_repositories.dart';
import 'package:expense_tracker/features/category/domain_layer/use_case/add_category_use_case.dart';
import 'package:expense_tracker/features/category/domain_layer/use_case/delete_category_use_case.dart';
import 'package:expense_tracker/features/category/domain_layer/use_case/get_all_category_use_case.dart';
import 'package:expense_tracker/features/category/presentation/bloc/category_bloc.dart';
import 'package:expense_tracker/features/ledger/data_layer/data_source/ledger_data_source.dart';
import 'package:expense_tracker/features/ledger/data_layer/repository/ledger_repository_impl.dart';
import 'package:expense_tracker/features/ledger/domain_layer/repositories/ledger_repositories.dart';
import 'package:expense_tracker/features/ledger/domain_layer/user_case/add_ledger_use_case.dart';
import 'package:expense_tracker/features/ledger/domain_layer/user_case/delete_ledger_use_case.dart';
import 'package:expense_tracker/features/ledger/domain_layer/user_case/update_ledger_use_case.dart';
import 'package:expense_tracker/features/ledger/presentation_layer/bloc/ledger_bloc.dart';
import 'package:expense_tracker/objectbox.g.dart';
import 'package:get_it/get_it.dart';
import 'package:path_provider/path_provider.dart';

import '../features/add_transaction/domain_layer/repositories/transaction_repositories.dart';
import '../features/category/domain_layer/use_case/update_category_use_case.dart';
import '../features/ledger/domain_layer/user_case/get_all_ledger_use_case.dart';

final sl = GetIt.instance;

Future<void> init() async {
  final dir = await getApplicationDocumentsDirectory();
  // print('Database directory: ${dir.path}/objectbox');
  // ObjectBox store
  final store = Store(getObjectBoxModel(), directory: '${dir.path}/objectbox');
  sl.registerSingleton<Store>(store);
  // for bloc
  sl.registerFactory(() => AddIncomeExpenseBloc(addTransactionUseCase: sl(), callTransactionUseCase: sl(), deleteTransactionUseCase: sl(), updateTransactionUseCase: sl()));
  sl.registerFactory(() => NavigationBloc());
  sl.registerFactory(() => CategoryBloc(getAllCategoryUseCase: sl()));
  sl.registerFactory(() => LedgerBloc(addLedgerUseCase: sl(), updateLedgerUseCase: sl(), deleteLedgerUseCase: sl(), getAllLedgerUseCase: sl()));
  sl.registerFactory(() => AuthBloc(signUpUseCase: sl(), getUserUseCase: sl(), profileUpdateUseCase: sl()));
  // for use case
  sl.registerLazySingleton(() => AddTransactionUseCase(repositories: sl()));
  sl.registerLazySingleton(() => CallTransactionUseCase(repositories: sl()));
  sl.registerLazySingleton(() => DeleteTransactionUseCase(repositories: sl()));
  sl.registerLazySingleton(() => UpdateTransactionUseCase(transactionRepositories: sl()));
  sl.registerLazySingleton(() => SignUpUseCase(signUpRepositories: sl()));
  sl.registerLazySingleton(() => GetUserUseCase(signUpRepositories: sl()));
  sl.registerLazySingleton(() => ProfileUpdateUseCase(signUpRepositories: sl()));
  //category use case
  sl.registerLazySingleton(() => AddCategoryUseCase(categoryRepositories: sl()));
  sl.registerLazySingleton(() => UpdateCategoryUseCase(categoryRepositories: sl()));
  sl.registerLazySingleton(() => DeleteCategoryUseCase(categoryRepositories: sl()));
  sl.registerLazySingleton(() => GetAllCategoryUseCase(categoryRepositories: sl()));
  //ledger use case
  sl.registerLazySingleton(() => AddLedgerUseCase(ledgerRepositories: sl()));
  sl.registerLazySingleton(() => UpdateLedgerUseCase(ledgerRepositories: sl()));
  sl.registerLazySingleton(() => DeleteLedgerUseCase(ledgerRepositories: sl()));
  sl.registerLazySingleton(() => GetAllLedgerUseCase(ledgerRepositories: sl()));
  // for repositories
  sl.registerLazySingleton<TransactionRepositories>(() => TransactionRepositoryImpl(transactionLocalDataSource: sl()));
  sl.registerLazySingleton<CategoryRepositories>(() => CategoryRepositoryImpl(categoryDataSource: sl()));
  sl.registerLazySingleton<LedgerRepositories>(() => LedgerRepositoryImpl(ledgerLocalDataSource: sl()));
  sl.registerLazySingleton<SignUpRepositories>(() => SignUpRepoImpl(signUpLocalDataSource: sl()));
  // for data source
  sl.registerLazySingleton<TransactionLocalDataSource>(() => TransactionLocalDataSourceImpl(sl()));
  sl.registerLazySingleton<CategoryDataSource>(() => CategoryDataSourceImpl(store: sl()));
  sl.registerLazySingleton<LedgerDataSource>(() => LedgerDataSourceImpl(store: sl()));
  sl.registerLazySingleton<SignUpLocalDataSource>(() => SignUpLocalDataSourceImpl(store: sl()));
}
