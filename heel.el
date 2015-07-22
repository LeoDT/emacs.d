(defun jsfmt()
  "format js with jsfmt"
  (interactive)
  (let (command p)
    (setq command "/usr/local/bin/js-beautify -f -")
    (setq p (point))
    (message command)
    (shell-command-on-region

     ;; beginning and end of buffer
     (point-min)
     (point-max)

     ;; command and parameters
     command

     ;; output buffer
     (current-buffer)

     ;; replace ?
     t

     ;; name of the error buffer
     "*jsfmt Error Buffer*"

     ;; show error buffer ?
     nil)
    (setq mark-active nil)
    (goto-char p)
    ))

(global-set-key(kbd "C-<tab>") 'jsfmt)
;; (add-hook 'js2-mode-hook
;;      (lambda()
;;        (add-hook 'before-save-hook 'jsfmt nil 'make-it-local)))

(defun qastg()
  (interactive)
  (beginning-of-buffer)
  (while (re-search-forward "http://\\(gw\\|app\\)" nil t)
    (replace-match "https://\\1"))
  (beginning-of-buffer)
  (while (re-search-forward "-qa" nil t)
    (replace-match "-stg"))
  )

(defun stgqa()
  (interactive)
  (beginning-of-buffer)
  (while (re-search-forward "https://\\(gw\\|app\\)" nil t)
    (replace-match "http://\\1"))
  (beginning-of-buffer)
  (while (re-search-forward "-stg" nil t)
    (replace-match "-qa"))
  )
