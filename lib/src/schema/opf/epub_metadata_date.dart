import 'package:equatable/equatable.dart';

class EpubMetadataDate extends Equatable {
  final String? id;
  final String? event;
  final String? date;

  const EpubMetadataDate({
    this.id,
    this.event,
    this.date,
  });

  EpubMetadataDate copyWith({
    String? id,
    String? event,
    String? date,
  }) {
    return EpubMetadataDate(
      id: id ?? this.id,
      event: event ?? this.event,
      date: date ?? this.date,
    );
  }

  @override
  List<Object?> get props => [id, event, date];
}
