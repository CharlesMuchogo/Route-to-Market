
class VisitFilters{

  final bool ascending;
  final String searchParam;
  final String? status;

  const  VisitFilters({this.ascending = false, this.searchParam = "", this.status});

  VisitFilters copyWith({
    bool? ascending,
    String? searchParam,
    String? status,
  }) {
    return VisitFilters(
      ascending: ascending ?? this.ascending,
      searchParam:  searchParam ?? this.searchParam,
      status: status ?? this.status,
    );
  }
}