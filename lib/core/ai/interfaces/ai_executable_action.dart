import 'package:either_dart/either.dart';

abstract class AiExecutableAction<Input, Output, Failure extends Error> {
  Future<Either<Failure, Output>> execute(Input input);

  Input fromJson(Map<String, dynamic> json);
}