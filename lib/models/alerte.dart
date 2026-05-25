class Alerte {
  final int    id;
  final String zone;
  final String message;
  final String date;
  final String heure;
  final int    valeur;
  final String tourelles;
  final String clapets;
  final String ouvrants;
  final String cta;
  final int    niveau;
  final String diagnostic;
  final double temperature;
  final double diffPression;

  Alerte({
    required this.id,
    required this.zone,
    required this.message,
    required this.date,
    required this.heure,
    required this.valeur,
    required this.tourelles,
    required this.clapets,
    required this.ouvrants,
    required this.cta,
    required this.niveau,
    required this.diagnostic,
    required this.temperature,
    required this.diffPression,
  });

  factory Alerte.fromJson(Map<String, dynamic> json) {
    return Alerte(
      id:           json['id']            ?? 0,
      zone:         json['zone']          ?? 'M1',
      message:      json['message']       ?? '',
      date:         json['date']          ?? '--/--/----',
      heure:        json['heure']         ?? '--:--',
      valeur:       json['valeur']        ?? 0,
      tourelles:    json['tourelles']     ?? 'INCONNU',
      clapets:      json['clapets']       ?? 'INCONNU',
      ouvrants:     json['ouvrants']      ?? 'INCONNU',
      cta:          json['cta']           ?? 'INCONNU',
      niveau:       json['niveau']        ?? 0,
      diagnostic:   json['diagnostic']    ?? 'INCONNU',
      temperature:  (json['temperature']  ?? 0).toDouble(),
      diffPression: (json['diff_pression'] ?? 0).toDouble(),
    );
  }
}