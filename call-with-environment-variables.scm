(module
 call-with-environment-variables
 (call-with-environment-variables)

 (import scheme chicken posix)

 (define (call-with-environment-variables variables thunk)
  (let ((pre-existing-variables
         (map (lambda (var-value)
                (let ((var (car var-value)))
                  (cons var (get-environment-variable var))))
              variables)))
    (dynamic-wind
        (lambda () (void))
        (lambda ()
          (for-each (lambda (var-value)
                      (setenv (car var-value) (cdr var-value)))
                    variables)
          (thunk))
        (lambda ()
          (for-each (lambda (var-value)
                      (let ((var (car var-value))
                            (value (cdr var-value)))
                        (if value
                            (setenv var value)
                            (unsetenv var))))
                    pre-existing-variables))))))
