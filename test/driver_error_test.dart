/// Tests for the DriverError sealed hierarchy.
import 'package:test/test.dart';

import 'package:bentos_driver_sdk/bentos_driver_sdk.dart';

void main() {
  group('DriverError', () {
    test('factory constructors produce correct subtypes', () {
      expect(DriverError.invalidArgument('x'), isA<InvalidArgumentError>());
      expect(DriverError.busy('x'), isA<BusyError>());
      expect(DriverError.notFound('x'), isA<NotFoundError>());
      expect(DriverError.notPermitted('x'), isA<NotPermittedError>());
      expect(DriverError.resourceExhausted('x'), isA<ResourceExhaustedError>());
      expect(DriverError.timedOut('x'), isA<TimedOutError>());
      expect(DriverError.ioError('x'), isA<IoError>());
      expect(DriverError.notSupported('x'), isA<NotSupportedError>());
      expect(DriverError.accessDenied('x'), isA<AccessDeniedError>());
      expect(DriverError.wouldBlock('x'), isA<WouldBlockError>());
    });

    test('errno values match POSIX', () {
      expect(DriverError.notPermitted('').errno, 1);
      expect(DriverError.notFound('').errno, 2);
      expect(DriverError.ioError('').errno, 5);
      expect(DriverError.wouldBlock('').errno, 11);
      expect(DriverError.resourceExhausted('').errno, 12);
      expect(DriverError.accessDenied('').errno, 13);
      expect(DriverError.busy('').errno, 16);
      expect(DriverError.invalidArgument('').errno, 22);
      expect(DriverError.notSupported('').errno, 38);
      expect(DriverError.timedOut('').errno, 110);
    });

    test('sealed hierarchy allows exhaustive switching', () {
      final DriverError err = DriverError.notFound('test');
      final result = switch (err) {
        InvalidArgumentError() => 'invalid',
        BusyError() => 'busy',
        NotFoundError() => 'not found',
        NotPermittedError() => 'not permitted',
        ResourceExhaustedError() => 'exhausted',
        TimedOutError() => 'timeout',
        IoError() => 'io',
        NotSupportedError() => 'not supported',
        AccessDeniedError() => 'access denied',
        WouldBlockError() => 'would block',
      };
      expect(result, equals('not found'));
    });

    test('message is preserved', () {
      final err = DriverError.invalidArgument('bad input');
      expect(err.message, equals('bad input'));
    });

    test('toString includes type and errno', () {
      final err = DriverError.notFound('key missing');
      expect(err.toString(), contains('NotFoundError'));
      expect(err.toString(), contains('2'));
      expect(err.toString(), contains('key missing'));
    });
  });
}
