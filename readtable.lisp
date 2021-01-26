(defpackage #:cmd/readtable
  (:use #:cl #:cmd)
  (:import-from :named-readtables)
  (:export :readtable))
(in-package :cmd/readtable)

(defun read-until (stream delimiter)
  "Return the string read until DELIMITER."
  (concatenate 'string
               (loop :for char = (read-char stream nil :eof)
                     :while (and (not (eq char :eof))
                                 (not (char= char delimiter)))
                     :collect char)))

(defun cmd-reader (stream char1 char2)
  (declare (ignore char1 char2))
  (cmd (read-until stream #\newline)))

(defun $cmd-reader (stream char1 char2)
  (declare (ignore char1 char2))
  ($cmd (read-until stream #\newline)))

(export-always 'readtable)
(named-readtables:defreadtable readtable
  (:merge :standard)
  (:dispatch-macro-char #\# #\! #'cmd-reader)
  (:dispatch-macro-char #\# #\$ #'$cmd-reader))
