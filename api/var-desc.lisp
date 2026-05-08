(in-package :cl-win32ole)

(defun make-var-desc (ptr-var-desc type-info)
  (let ((memid (cffi:foreign-slot-value ptr-var-desc '(:struct VARDESC) 'memid)))
    (make-instance
     'var-desc
     :name (get-name-of-documentation type-info memid)
     :memid memid
     :value (to-lisp (cffi:foreign-slot-value ptr-var-desc '(:struct VARDESC) 'value))
     :varkind (cffi:foreign-slot-value ptr-var-desc '(:struct VARDESC) 'varkind)
     :var-flags (cffi:foreign-slot-value ptr-var-desc '(:struct VARDESC) 'wVarFlags)
     )))

(defmethod constant-p ((var-desc var-desc))
  (= VAR_CONST (varkind var-desc)))

(defmethod loadable-const-p ((var-desc var-desc))
  (and (constant-p var-desc)
       (logand (var-flags var-desc)
               (logior VARFLAG_FHIDDEN
                       VARFLAG_FRESTRICTED
                       VARFLAG_FNONBROWSABLE))))
