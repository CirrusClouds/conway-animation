;;;; gol.lisp

(in-package #:sdl-in-lisp)

(defconstant NO_OF_CELLS 100)

(defun range (first &optional (second nil) (step 1))
  (macrolet ((for (second word first)
               `(loop :for x :from ,second ,word ,first :by step
                      :collect x)))
    (cond ((and second (> second first)) (for first to second))
          (second (for first downto second))
          (t (for 0 to first)))))

(defun cell-state-p (sym)
  (or 'Dead 'Alive))

(deftype cell ()
  '(and symbol
    (satisfies cell-state-p)))

(defun right-dimensions-p (b)
  (and (= (array-rank b) 2)
       (apply #'= (array-dimensions b))))

(deftype board ()
  '(and (array cell)
    (satisfies right-dimensions-p)))

(setf *board* (make-array (list NO_OF_CELLS NO_OF_CELLS) :element-type 'cell :initial-element 'Dead))
(setf (aref *board* 0 1) 'Alive)
(setf (aref *board* 1 2) 'Alive)
(setf (aref *board* 2 0) 'Alive)
(setf (aref *board* 2 1) 'Alive)
(setf (aref *board* 2 2) 'Alive)
(setf (aref *board* 2 2) 'Alive)
(setf (aref *board* 10 4) 'Alive)
(setf (aref *board* 4 10) 'Alive)
(setf (aref *board* 4 11) 'Alive)
(setf (aref *board* 4 12) 'Alive)
(setf (aref *board* 4 13) 'Alive)
(setf (aref *board* 7 10) 'Alive)
(setf (aref *board* 44 11) 'Alive)
(setf (aref *board* 44 12) 'Alive)
(setf (aref *board* 44 13) 'Alive)
(setf (aref *board* 70 10) 'Alive)
(setf (aref *board* 80 11) 'Alive)
(setf (aref *board* 90 12) 'Alive)
(setf (aref *board* 10 12) 'Alive)
(setf (aref *board* 7 12) 'Alive)
(setf (aref *board* 4 22) 'Alive)
(setf (aref *board* 4 23) 'Alive)
(setf (aref *board* 7 20) 'Alive)
(setf (aref *board* 4 21) 'Alive)
(setf (aref *board* 5 21) 'Alive)(setf (aref *board* 44 11) 'Alive)
(setf (aref *board* 44 12) 'Alive)
(setf (aref *board* 44 13) 'Alive)
(setf (aref *board* 70 10) 'Alive)
(setf (aref *board* 80 11) 'Alive)
(setf (aref *board* 5 12) 'Alive)
(setf (aref *board* 55 12) 'Alive)
(setf (aref *board* 56 12) 'Alive)
(setf (aref *board* 54 22) 'Alive)
(setf (aref *board* 53 23) 'Alive)
(setf (aref *board* 52 20) 'Alive)
(setf (aref *board* 51 21) 'Alive)
(setf (aref *board* 5 22) 'Alive)
(setf (aref *board* 6 23) 'Alive)
(setf (aref *board* 7 10) 'Alive)
(setf (aref *board* 4 10) 'Alive)
(setf (aref *board* 4 11) 'Alive)
(setf (aref *board* 4 12) 'Alive)
(setf (aref *board* 4 13) 'Alive)
(setf (aref *board* 7 10) 'Alive)

(cl-utils:tefun count-neighbours ('board b 'integer i 'integer j) 'integer
  (let ((r 0))
    (loop :for i1 :in (cl-utils:range (- i 1) (+ i 1))
          :do
             (if (< i1 0)
                 (setf i1 (- NO_OF_CELLS 1))
                 (if (> i1 (- NO_OF_CELLS 1))
                     (setf i1 0)))
             (loop :for j1 in (cl-utils:range (- j 1) (+ j 1))
                   :do
                      (if (< j1 0)
                          (setf j1 (- NO_OF_CELLS 1))
                          (if (> j1 (- NO_OF_CELLS 1))
                              (setf j1 0)))
                      (if
                           ;; (or (> j1 (- NO_OF_CELLS 1)) (< j1 1) (> i1 (- NO_OF_CELLS 1)) (< i1 1))

                          (and (= j1 j) (= i1 i))
                          nil
                          (if (equal (aref b i1 j1) 'Alive)
                              (setf r (+ r 1))
                              nil))))
    r))

(cl-utils:tefun next ('board b) 'board
  (let ((result (make-array (list NO_OF_CELLS NO_OF_CELLS) :element-type 'cell)))
    (mapc (lambda (i)
            (mapc (lambda (j)
                    (let ((N (count-neighbours b i j)))
                      (cond ((and (= N 3) (equal (aref b i j) 'Dead))
                             (setf (aref result i j) 'Alive))
                            ((not (or (= N 3) (= N 2)))
                             (setf (aref result i j) 'Dead))
                            (t
                             (setf (aref result i j) (aref b i j))))))
                  (cl-utils:range (- NO_OF_CELLS 1))))
          (cl-utils:range (- NO_OF_CELLS 1)))
    result))
