class Jatekos {
  String nev;
  String csapat;
  int gol;
  int assziszt;
  double kiallitasPerc;
  double price;

  Jatekos(this.nev, this.csapat, this.gol, this.assziszt, this.kiallitasPerc)
      : price = double.parse(
            ((gol * 2 + assziszt - kiallitasPerc) / 3).toStringAsFixed(2));

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Jatekos &&
          runtimeType == other.runtimeType &&
          nev == other.nev &&
          csapat == other.csapat &&
          gol == other.gol &&
          assziszt == other.assziszt &&
          kiallitasPerc == other.kiallitasPerc &&
          price == other.price;

  @override
  int get hashCode =>
      nev.hashCode ^
      csapat.hashCode ^
      gol.hashCode ^
      assziszt.hashCode ^
      kiallitasPerc.hashCode ^
      price.hashCode;
}
