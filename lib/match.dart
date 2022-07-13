class Match {
  int round;
  String date;
  String homeTeam;
  String guestTeam;
  String result;

  Match(this.round, this.date, this.homeTeam, this.guestTeam, this.result);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Match &&
          runtimeType == other.runtimeType &&
          round == other.round &&
          date == other.date &&
          homeTeam == other.homeTeam &&
          guestTeam == other.guestTeam &&
          result == other.result;

  @override
  int get hashCode =>
      round.hashCode ^
      date.hashCode ^
      homeTeam.hashCode ^
      guestTeam.hashCode ^
      result.hashCode;
}
