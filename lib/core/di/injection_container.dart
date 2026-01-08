import 'package:condo_hub_app/features/auth/data/datasources/auth_local_datasource.dart';
import 'package:condo_hub_app/features/auth/data/datasources/auth_remote_datasource.dart';
import 'package:condo_hub_app/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:condo_hub_app/features/auth/domain/repositories/auth_repository.dart';
import 'package:condo_hub_app/features/auth/domain/usecases/authenticate_biometric.dart';
import 'package:condo_hub_app/features/auth/domain/usecases/login_user.dart';
import 'package:condo_hub_app/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:condo_hub_app/features/dashboard/data/datasources/announcement_datasource.dart';
import 'package:condo_hub_app/features/dashboard/data/repositories/announcement_repository_impl.dart';
import 'package:condo_hub_app/features/dashboard/domain/repositories/announcement_repository.dart';
import 'package:condo_hub_app/features/dashboard/domain/usecases/get_announcements.dart';
import 'package:condo_hub_app/features/dashboard/presentation/cubit/dashboard_cubit.dart';
import 'package:condo_hub_app/features/messages/data/datasources/message_datasource.dart';
import 'package:condo_hub_app/features/messages/data/repositories/message_repository_impl.dart';
import 'package:condo_hub_app/features/messages/domain/repositories/message_repository.dart';
import 'package:condo_hub_app/features/messages/domain/usecases/get_messages.dart';
import 'package:condo_hub_app/features/messages/domain/usecases/send_message.dart';
import 'package:condo_hub_app/features/messages/presentation/cubit/messages_cubit.dart';
import 'package:condo_hub_app/features/onboarding/data/datasources/condominium_local_datasource.dart';
import 'package:condo_hub_app/features/onboarding/data/datasources/condominium_remote_datasource.dart';
import 'package:condo_hub_app/features/onboarding/data/repositories/condominium_repository_impl.dart';
import 'package:condo_hub_app/features/onboarding/domain/repositories/condominium_repository.dart';
import 'package:condo_hub_app/features/onboarding/domain/usecases/identify_condominium.dart';
import 'package:condo_hub_app/features/onboarding/presentation/cubit/onboarding_cubit.dart';
import 'package:condo_hub_app/features/payments/data/datasources/payment_datasource.dart';
import 'package:condo_hub_app/features/payments/data/repositories/payment_repository_impl.dart';
import 'package:condo_hub_app/features/payments/domain/repositories/payment_repository.dart';
import 'package:condo_hub_app/features/payments/domain/usecases/generate_pix.dart';
import 'package:condo_hub_app/features/payments/domain/usecases/get_payments.dart';
import 'package:condo_hub_app/features/payments/presentation/cubit/payments_cubit.dart';
import 'package:local_auth/local_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ServiceLocator {
  static SharedPreferences? _sharedPreferences;
  static LocalAuthentication? _localAuth;

  static CondominiumRepository? _condominiumRepository;
  static AuthRepository? _authRepository;
  static AnnouncementRepository? _announcementRepository;
  static PaymentRepository? _paymentRepository;
  static MessageRepository? _messageRepository;

  static Future<void> init() async {
    _sharedPreferences = await SharedPreferences.getInstance();
    _localAuth = LocalAuthentication();
  }

  static SharedPreferences get sharedPreferences {
    if (_sharedPreferences == null) {
      throw Exception('ServiceLocator not initialized. Call init() first.');
    }
    return _sharedPreferences!;
  }

  static LocalAuthentication get localAuth {
    if (_localAuth == null) {
      throw Exception('ServiceLocator not initialized. Call init() first.');
    }
    return _localAuth!;
  }

  static CondominiumRepository get condominiumRepository {
    _condominiumRepository ??= CondominiumRepositoryImpl(
      remoteDataSource: CondominiumRemoteDataSourceImpl(),
      localDataSource: CondominiumLocalDataSourceImpl(
        sharedPreferences: sharedPreferences,
      ),
    );
    return _condominiumRepository!;
  }

  static AuthRepository get authRepository {
    _authRepository ??= AuthRepositoryImpl(
      remoteDataSource: AuthRemoteDataSourceImpl(),
      localDataSource: AuthLocalDataSourceImpl(
        sharedPreferences: sharedPreferences,
        localAuth: localAuth,
      ),
    );
    return _authRepository!;
  }

  static AnnouncementRepository get announcementRepository {
    _announcementRepository ??= AnnouncementRepositoryImpl(
      dataSource: AnnouncementDataSourceImpl(
        sharedPreferences: sharedPreferences,
      ),
    );
    return _announcementRepository!;
  }

  static PaymentRepository get paymentRepository {
    _paymentRepository ??= PaymentRepositoryImpl(
      dataSource: PaymentDataSourceImpl(
        sharedPreferences: sharedPreferences,
      ),
    );
    return _paymentRepository!;
  }

  static MessageRepository get messageRepository {
    _messageRepository ??= MessageRepositoryImpl(
      dataSource: MessageDataSourceImpl(
        sharedPreferences: sharedPreferences,
      ),
    );
    return _messageRepository!;
  }

  static OnboardingCubit createOnboardingCubit() {
    return OnboardingCubit(
      identifyCondominium: IdentifyCondominium(condominiumRepository),
      repository: condominiumRepository,
    );
  }

  static AuthBloc createAuthBloc() {
    return AuthBloc(
      loginUser: LoginUser(authRepository),
      authenticateBiometric: AuthenticateBiometric(authRepository),
      repository: authRepository,
    );
  }

  static DashboardCubit createDashboardCubit() {
    return DashboardCubit(
      getAnnouncements: GetAnnouncements(announcementRepository),
      repository: announcementRepository,
    );
  }

  static PaymentsCubit createPaymentsCubit() {
    return PaymentsCubit(
      getPayments: GetPayments(paymentRepository),
      generatePixKey: GeneratePixKey(paymentRepository),
      generatePixQRCode: GeneratePixQRCode(paymentRepository),
      repository: paymentRepository,
    );
  }

  static MessagesCubit createMessagesCubit() {
    return MessagesCubit(
      getMessages: GetMessages(messageRepository),
      sendMessage: SendMessage(messageRepository),
      repository: messageRepository,
    );
  }
}
