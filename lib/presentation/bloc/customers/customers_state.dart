part of 'customers_bloc.dart';

class CustomersState extends Equatable {
  final List customers;
  final CustomersStatus status;
  final String message;

  const CustomersState({
    this.customers = const [],
    this.message = "",
    this.status = CustomersStatus.initial,
  });

  CustomersState copyWith({
    List? customers,
    String? message,
    CustomersStatus? status,
    bool? loggedIn,
  }) {
    return CustomersState(
      customers: customers ?? this.customers,
      status: status ?? this.status,
      message: message ?? this.message
    );
  }

  @override
  List<Object> get props => [customers, status, message];

  Map<String, dynamic> toMap() {
    return <String, dynamic>{'customers': customers, 'message': message , 'status': status.index};
  }

  factory CustomersState.fromMap(Map<String, dynamic> map) {
    int index = map['status'];

    return CustomersState(
      customers: List.from((map['customers'] as List)),
      message: map['message'] ,
      status: CustomersStatus.values[index],
    );
  }

  String toJson() => json.encode(toMap());

  factory CustomersState.fromJson(String source) =>
      CustomersState.fromMap(json.decode(source) as Map<String, dynamic>);
}

enum CustomersStatus { initial, loading, loaded, error, failed, success }
