(add-to-list 'exec-path (concat (getenv "HOME") "/.local/bin"))

(require 'bind-key)
(global-set-key (kbd "C-t") 'set-mark-command)
(bind-key* (kbd "M-<tab>") 'other-window)
(global-set-key (kbd "C-x C-k") 'kill-current-buffer)
(global-set-key (kbd "C-x C-b") 'ibuffer-other-window)

;; config
(setq-default make-backup-files nil)
(setq-default indent-tabs-mode nil)
(setq tab-always-indent nil)
(setq tab-width 2)
(setq kill-whole-line t)
(fset 'yes-or-no-p 'y-or-n-p)
(setq electric-indent-inhibit t)
(setq dired-listing-switches "-aBhl --group-directories-first")

;; move lock files like .#abc.js to tmp
(setq lock-file-name-transforms
      '(("\\`/.*/\\([^/]+\\)\\'" "/var/tmp/\\1" t)))

(setq ibuffer-expert t)
(add-hook 'ibuffer-mode-hook
	        '(lambda ()
	           (ibuffer-auto-mode 1)))

(require 'package)
(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/") t)
(package-initialize)

;; https://github.com/adimit/config/blob/f84b34c04d101bdd33e180c07715ce481608ba9f/emacs/main.org#work-around-null-bytes-in-json-response
;; same definition as mentioned earlier
(advice-add 'json-parse-string :around
            (lambda (orig string &rest rest)
              (apply orig (while (re-search-forward "\\[uU]0000" nil t)
			    (replace-match "?"))
                     rest)))

;; minor changes: saves excursion and uses search-forward instead of re-search-forward
(advice-add 'json-parse-buffer :around
            (lambda (oldfn &rest args)
	      (save-excursion 
                (while (re-search-forward "\\[uU]0000" nil t)
		  (replace-match "?")))
	      (apply oldfn args)))

;; use-package to simplify the config file
(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))
(require 'use-package)
(setq use-package-always-ensure 't)

;; Keyboard-centric user interface
(setq inhibit-startup-message t)
(tool-bar-mode -1)
(menu-bar-mode -1)
(scroll-bar-mode -1)
(show-paren-mode 1)

;; some performance optimizations
(setq gc-cons-threshold 100000000)
(setq read-process-output-max (* 1024 1024))

(add-hook 'find-file-hook 'auto-insert)
(setq auto-insert-directory "~/.emacs.d/auto-insert/")
(setq auto-insert-query nil)
(define-auto-insert "\\.astro\\'" "astro")

(use-package so-long
  :init
  (global-so-long-mode 1))

;; projectile
(use-package projectile
  :init
  (projectile-mode +1)
  :config
  (setq projectile-project-search-path '("~/src/" "~/work/" ("~/github" . 1)))
  (projectile-register-project-type 'npm '("package-lock.json")
				    :compile "npm build"
				    :test "npm test"
				    :run "npm start")
  (projectile-register-project-type 'yarn '("yarn.lock")
				    :compile "yarn build"
				    :test "yarn run test"
				    :run "yarn run start")
  :bind (:map projectile-mode-map
              ("C-c p" . projectile-command-map)
	      ("C-x f" . projectile-find-file)))

(use-package ibuffer-vc
  :config
  (add-hook 'ibuffer-hook
            (lambda ()
              (ibuffer-vc-set-filter-groups-by-vc-root)
              (unless (eq ibuffer-sorting-mode 'alphabetic)
                (ibuffer-do-sort-by-alphabetic)))))

;; editorconfig
(use-package editorconfig
  :config
  (editorconfig-mode 1))

;; which key
(use-package which-key
  :config
  (which-key-mode)
  (setq which-key-idle 0.5
	which-key-idle-delay 50)
  (which-key-setup-minibuffer))

(use-package multiple-cursors
  :init
  (global-unset-key (kbd "M-<down-mouse-1>"))
  :bind (
         ("C-d" . mc/mark-next-like-this)
         ("M-<mouse-1>" . mc/add-cursor-on-click)))

(use-package smartparens
  :bind (
         ("C-M-f" . sp-forward-sexp)
         ("C-M-b" . sp-backward-sexp)
         ("C-M-n" . sp-next-sexp)
         ("C-M-p" . sp-previous-sexp))
  :hook (
         (web-mode . smartparens-mode)
         (elisp . smartparens-mode)))

;; flycheck print errors more than 1 line, which flymake don't
(use-package flycheck)

;; Vertico
(use-package vertico
  :init
  (vertico-mode))

;; Persist history over Emacs restarts. Vertico sorts by history position.
(use-package savehist
  :init
  (savehist-mode))

(use-package recentf
  :init
  (recentf-mode))

(use-package yasnippet
  :config
  (yas-global-mode))

(use-package yasnippet-snippets)

(use-package eglot
  :config
  (add-to-list 'eglot-server-programs
               '(web-mode . ("typescript-language-server" "--stdio")))
  :bind (
	 ("C-." . eglot-code-actions)))

(with-eval-after-load 'eglot
   (setq completion-category-defaults nil))

(setq completion-styles '(basic substring partial-completion flex)
      read-file-name-completion-ignore-case t
      read-buffer-completion-ignore-case t
      completion-ignore-case t)

(use-package corfu
  :custom
  (corfu-cycle t)
  (corfu-auto t)
  (corfu-preview-current nil)
  :init
  (global-corfu-mode))

;; ;; A few more useful configurations...
(use-package emacs
  :init
  ;; Enable indentation+completion using the TAB key.
  ;; `completion-at-point' is often bound to M-TAB.
  (setq tab-always-indent 'complete))

(use-package cape
  :init
  ;; Add `completion-at-point-functions', used by `completion-at-point'.
  (add-to-list 'completion-at-point-functions #'cape-dabbrev)
  (add-to-list 'completion-at-point-functions #'cape-file)
  )

;; Consult
(use-package consult
  :bind (
	 ("C-x b" . consult-buffer)
	 ("M-y" . consult-yank-pop))
  :config
  (setq consult-preview-key "M-.")
  (setq consult-project-root-function #'projectile-project-root))

;;  Marginalia
(use-package marginalia
  :bind (
	 :map minibuffer-local-map
         ("M-A" . marginalia-cycle))
  :init
  (marginalia-mode))

(use-package embark
  :bind (
	 ("C-'" . embark-act))
  :init
  (setq prefix-help-command #'embark-prefix-help-command)
  :config
  (add-to-list 'display-buffer-alist
               '("\\`\\*Embark Collect \\(Live\\|Completions\\)\\*"
                 nil
                 (window-parameters (mode-line-format . none))))
  )

(use-package embark-consult
  :after (embark consult)
  :demand t ; only necessary if you have the hook below
  ;; if you want to have consult previews as you move around an
  ;; auto-updating embark collect buffer
  :hook
  (embark-collect-mode . consult-preview-at-point-mode))

;; (use-package jinx
;;   :hook (emacs-startup . global-jinx-mode)
;;   :bind (("M-$" . jinx-correct)
;;          ("C-M-$" . jinx-languages)))

;; ripgrep
(use-package rg)

;; wgrep
(use-package wgrep)

;; magit
(use-package magit)

(use-package diff-hl
  :init
  (global-diff-hl-mode))

;; dracula theme
(use-package dracula-theme
  :init
  (load-theme 'dracula t))

;; mode line
(use-package doom-modeline
  :init
  (doom-modeline-mode 1))

(setq doom-modeline-height 1)
(setq all-the-icons-scale-factor 1)
(setq doom-modeline-icon nil)
(set-face-attribute 'mode-line nil :family "JetBrains Mono" :height 120)
(set-face-attribute 'mode-line-inactive nil :family "JetBrains Mono" :height 120)

;; lsp
(use-package lsp-mode
  :init
  (setq lsp-keymap-prefix "C-c l")
  (defun my/lsp-mode-setup-completion ()
    (setf (alist-get 'styles (alist-get 'lsp-capf completion-category-defaults))
          '(flex))) ;; Configure flex
  :hook (
	 (lsp-completion-mode . my/lsp-mode-setup-completion)
         (javascript-mode . lsp-deferred)
         (web-mode . lsp-deferred)
	 (gdscript-mode . lsp-deferred)
         (js2-mode . lsp-deferred)
         (lsp-mode . lsp-enable-which-key-integration))
  :commands (lsp lsp-deferred)
  :custom
  (lsp-eslint-auto-fix-on-save t)
  ;; (lsp-eslint-trace-server "on")
  (lsp-clients-typescript-prefer-use-project-ts-server t)
  ;; (lsp-clients-typescript-server-args '("--stdio" "--tsserver-log-file" "/dev/stderr"))
  (lsp-completion-provider :none) ;; we use Corfu!
  :config
  ;; (setq lsp-log-io t)
  (setq lsp-signature-render-documentation nil)
  (setq lsp-completion-provider :none)
  (setq lsp-idle-delay 0.500)
  (setq lsp-javascript-display-inlay-hints t)
  :bind (
	 ("C-." . lsp-execute-code-action)))

;; (use-package lsp-ui
;;   :commands lsp-ui-mode
;;   :config
;;   (define-key lsp-ui-mode-map [remap xref-find-definitions] #'lsp-ui-peek-find-definitions)
;;   (define-key lsp-ui-mode-map [remap xref-find-references] #'lsp-ui-peek-find-references)
;;   :custom
;;   (lsp-ui-peek-enable t)
;;   (lsp-ui-doc-show-with-cursor t)
;;   (lsp-ui-doc-show-with-mouse t)
;;   (lsp-ui-doc-position 'at-point)
;;   (lsp-ui-doc-delay 1))

(defun lsp--eslint-before-save (orig-fun)
  "Run lsp-eslint-apply-all-fixes and then run the original lsp--before-save."
  (when lsp-eslint-auto-fix-on-save (lsp-eslint-fix-all))
  (funcall orig-fun))

(advice-add 'lsp--before-save :around #'lsp--eslint-before-save)

;; (add-to-list 'auto-mode-alist '("\\.ts\\'" . typescript-ts-mode))
;; (add-to-list 'auto-mode-alist '("\\.tsx\\'" . tsx-ts-mode))

(use-package web-mode
  :mode (("\\.js\\'" . web-mode)
         ("\\.jsx\\'" . web-mode)
         ("\\.ts\\'" . web-mode)
         ("\\.tsx\\'" . web-mode)
         ("\\.html\\'" . web-mode)
         ("\\.vue\\'" . web-mode)
         ("\\.json\\'" . web-mode)
	 ("\\.astro\\'" . web-mode))
  :commands web-mode
  :config
  (setq web-mode-content-types-alist
        '(("jsx" . "\\.js[x]?\\'")))
  (setq web-mode-enable-auto-quoting nil)
  (setq web-mode-enable-auto-indentation nil)
  (setq web-mode-enable-current-element-highlight t)
  (setq web-mode-enable-front-matter-block t)
  :custom
  (web-mode-markup-indent-offset 2)
  (web-mode-css-indent-offset 2)
  (web-mode-code-indent-offset 2))

(use-package lsp-treemacs
  :init
  (lsp-treemacs-sync-mode 1))

(use-package emmet-mode
  :hook (
         (web-mode . emmet-mode)
         (css-mode . emmet-mode)
         (scss-mode . emmet-mode))
  )

(use-package prettier
  :init
  (global-prettier-mode)
  :hook (
         (web-mode . prettier-mode)))

(use-package flow-minor-mode
  :hook (
	 (web-mode . flow-minor-enable-automatically)))

(use-package add-node-modules-path
  :config
  ;; automatically run the function when web-mode starts
  (eval-after-load 'web-mode
    '(add-hook 'web-mode-hook 'add-node-modules-path)))

(use-package restclient
  :mode (
         ("\\.http\\'" . restclient-mode)))
(use-package company-restclient
  :config
  (add-hook 'restclient-mode-hook
            (lambda ()
              (set (make-local-variable 'company-backends) '(company-restclient))
	      (company-fuzzy-mode 0))))
(defun http ()
  (interactive)
  (switch-to-buffer (find-file "~/requests.http")))

(use-package fish-mode
  :mode (
	 ("\\.fish\\'" . fish-mode)))

(use-package yaml-mode
  :mode (
	 ("\\.yaml\\'" . yaml-mode)
	 ("\\.yml\\'" . yaml-mode)))

(use-package markdown-mode
  :commands (markdown-mode gfm-mode)
  :mode (("README\\.md\\'" . gfm-mode)
         ("\\.md\\'" . gfm-mode)
         ("\\.markdown\\'" . gfm-mode))
  :init (setq markdown-command "pandoc -t html5"))

(use-package markdown-preview-mode
  :config
  (setq markdown-preview-stylesheets (list "https://cdnjs.cloudflare.com/ajax/libs/github-markdown-css/5.1.0/github-markdown-light.min.css")))

(use-package bison-mode
  :mode (("\\.bison" . bison-mode)
	 ("\\.jison" . bison-mode)))

(use-package rust-mode
  :config
  (setq rust-format-on-save t)
  :mode (("\\.rs" . rust-mode)))

(use-package sql-indent
  :hook (
	 (sql-mode . sqlind-minor-mode)))

(use-package dotenv-mode
  :mode (("\\.env" . dotenv-mode)))

;; (use-package indent-bars
;;   :load-path "~/github/indent-bars/"
;;   :config
;;   (setq indent-tabs-mode nil)
;;   :hook ((web-mode) . indent-bars-mode)) ; or whichever modes you prefer

(use-package dired-rainbow
  :config
  (progn
    (dired-rainbow-define-chmod directory "#6cb2eb" "d.*")
    (dired-rainbow-define html "#eb5286" ("css" "less" "sass" "scss" "htm" "html" "jhtm" "mht" "eml" "mustache" "xhtml"))
    (dired-rainbow-define xml "#f2d024" ("xml" "xsd" "xsl" "xslt" "wsdl" "bib" "json" "msg" "pgn" "rss" "yaml" "yml" "rdata"))
    (dired-rainbow-define document "#9561e2" ("docm" "doc" "docx" "odb" "odt" "pdb" "pdf" "ps" "rtf" "djvu" "epub" "odp" "ppt" "pptx"))
    (dired-rainbow-define markdown "#ffed4a" ("org" "etx" "info" "markdown" "md" "mkd" "nfo" "pod" "rst" "tex" "textfile" "txt"))
    (dired-rainbow-define database "#6574cd" ("xlsx" "xls" "csv" "accdb" "db" "mdb" "sqlite" "nc"))
    (dired-rainbow-define media "#de751f" ("mp3" "mp4" "MP3" "MP4" "avi" "mpeg" "mpg" "flv" "ogg" "mov" "mid" "midi" "wav" "aiff" "flac"))
    (dired-rainbow-define image "#f66d9b" ("tiff" "tif" "cdr" "gif" "ico" "jpeg" "jpg" "png" "psd" "eps" "svg"))
    (dired-rainbow-define log "#c17d11" ("log"))
    (dired-rainbow-define shell "#f6993f" ("awk" "bash" "bat" "sed" "sh" "zsh" "vim"))
    (dired-rainbow-define interpreted "#38c172" ("py" "ipynb" "rb" "pl" "t" "msql" "mysql" "pgsql" "sql" "r" "clj" "cljs" "scala" "js" "jsx" "ts" "tsx"))
    (dired-rainbow-define compiled "#4dc0b5" ("asm" "cl" "lisp" "el" "c" "h" "c++" "h++" "hpp" "hxx" "m" "cc" "cs" "cp" "cpp" "go" "f" "for" "ftn" "f90" "f95" "f03" "f08" "s" "rs" "hi" "hs" "pyc" ".java"))
    (dired-rainbow-define executable "#8cc4ff" ("exe" "msi"))
    (dired-rainbow-define compressed "#51d88a" ("7z" "zip" "bz2" "tgz" "txz" "gz" "xz" "z" "Z" "jar" "war" "ear" "rar" "sar" "xpi" "apk" "xz" "tar"))
    (dired-rainbow-define packaged "#faad63" ("deb" "rpm" "apk" "jad" "jar" "cab" "pak" "pk3" "vdf" "vpk" "bsp"))
    (dired-rainbow-define encrypted "#ffed4a" ("gpg" "pgp" "asc" "bfe" "enc" "signature" "sig" "p12" "pem"))
    (dired-rainbow-define fonts "#6cb2eb" ("afm" "fon" "fnt" "pfb" "pfm" "ttf" "otf"))
    (dired-rainbow-define partition "#e3342f" ("dmg" "iso" "bin" "nrg" "qcow" "toast" "vcd" "vmdk" "bak"))
    (dired-rainbow-define vc "#0074d9" ("git" "gitignore" "gitattributes" "gitmodules"))
    (dired-rainbow-define-chmod executable-unix "#38c172" "-.*x.*")
    ))

(use-package restclient
  :mode (("\\.http" . restclient-mode)))

(use-package gdscript-mode
  :mode (("\\.gd" . gdscript-mode))
  :init
  (setq gdscript-indent-offset 4)
  (setq gdscript-godot-executable "/usr/bin/godot")
  (setq gdscript-gdformat-executable "/home/leodt/.local/bin/gdformat")
  (setq gdscript-gdformat-save-and-format t))

(use-package lsp-prisma
  :load-path "packages/prisma/")
(use-package prisma-mode
  :load-path "packages/prisma/")

(use-package dirvish
  :init
  (dirvish-override-dired-mode))

(defun lsp--gdscript-ignore-errors (original-function &rest args)
  "Ignore the error message resulting from Godot not replying to the `JSONRPC' request."
  (if (string-equal major-mode "gdscript-mode")
      (let ((json-data (nth 0 args)))
        (if (and (string= (gethash "jsonrpc" json-data "") "2.0")
                 (not (gethash "id" json-data nil))
                 (not (gethash "method" json-data nil)))
            nil ; (message "Method not found")
          (apply original-function args)))
    (apply original-function args)))
;; Runs the function `lsp--gdscript-ignore-errors` around `lsp--get-message-type` to suppress unknown notification errors.
(advice-add #'lsp--get-message-type :around #'lsp--gdscript-ignore-errors)

;; font
(defun my/set-fonts ()
  (interactive)
  (setq use-default-font-for-symbols nil)
  (set-face-attribute 'default nil :family "JetBrains Mono" :height 120)
  (set-fontset-font t 'han (font-spec :family "Noto Sans CJK SC" :height 120) nil 'append)
  (setq face-font-rescale-alist '(("Noto Sans CJK SC" . 1.2)))
  (set-fontset-font t 'symbol "Noto Color Emoji" nil 'append))

(add-hook 'after-make-frame-functions #'(lambda (frame)
					 (select-frame frame)
					 (when (display-graphic-p frame)
					   (my/set-fonts))))
(add-hook 'window-setup-hook 'my/set-fonts)

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(ansi-color-faces-vector
   [default default default italic underline success warning error])
 '(ansi-color-names-vector
   ["#2e3436" "#a40000" "#4e9a06" "#c4a000" "#204a87" "#5c3566" "#729fcf" "#eeeeec"])
 '(connection-local-criteria-alist
   '(((:application tramp)
      tramp-connection-local-default-system-profile tramp-connection-local-default-shell-profile)))
 '(connection-local-profile-alist
   '((tramp-connection-local-darwin-ps-profile
      (tramp-process-attributes-ps-args "-acxww" "-o" "pid,uid,user,gid,comm=abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ" "-o" "state=abcde" "-o" "ppid,pgid,sess,tty,tpgid,minflt,majflt,time,pri,nice,vsz,rss,etime,pcpu,pmem,args")
      (tramp-process-attributes-ps-format
       (pid . number)
       (euid . number)
       (user . string)
       (egid . number)
       (comm . 52)
       (state . 5)
       (ppid . number)
       (pgrp . number)
       (sess . number)
       (ttname . string)
       (tpgid . number)
       (minflt . number)
       (majflt . number)
       (time . tramp-ps-time)
       (pri . number)
       (nice . number)
       (vsize . number)
       (rss . number)
       (etime . tramp-ps-time)
       (pcpu . number)
       (pmem . number)
       (args)))
     (tramp-connection-local-busybox-ps-profile
      (tramp-process-attributes-ps-args "-o" "pid,user,group,comm=abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ" "-o" "stat=abcde" "-o" "ppid,pgid,tty,time,nice,etime,args")
      (tramp-process-attributes-ps-format
       (pid . number)
       (user . string)
       (group . string)
       (comm . 52)
       (state . 5)
       (ppid . number)
       (pgrp . number)
       (ttname . string)
       (time . tramp-ps-time)
       (nice . number)
       (etime . tramp-ps-time)
       (args)))
     (tramp-connection-local-bsd-ps-profile
      (tramp-process-attributes-ps-args "-acxww" "-o" "pid,euid,user,egid,egroup,comm=abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ" "-o" "state,ppid,pgid,sid,tty,tpgid,minflt,majflt,time,pri,nice,vsz,rss,etimes,pcpu,pmem,args")
      (tramp-process-attributes-ps-format
       (pid . number)
       (euid . number)
       (user . string)
       (egid . number)
       (group . string)
       (comm . 52)
       (state . string)
       (ppid . number)
       (pgrp . number)
       (sess . number)
       (ttname . string)
       (tpgid . number)
       (minflt . number)
       (majflt . number)
       (time . tramp-ps-time)
       (pri . number)
       (nice . number)
       (vsize . number)
       (rss . number)
       (etime . number)
       (pcpu . number)
       (pmem . number)
       (args)))
     (tramp-connection-local-default-shell-profile
      (shell-file-name . "/bin/sh")
      (shell-command-switch . "-c"))
     (tramp-connection-local-default-system-profile
      (path-separator . ":")
      (null-device . "/dev/null"))))
 '(custom-safe-themes
   '("3c83b3676d796422704082049fc38b6966bcad960f896669dfc21a7a37a748fa" default))
 '(package-selected-packages
   '(flycheck transpose-frame sql-indent dap-mode eglot w3m js2-mode js-mode dotenv-mode bison-mode ibuffer-vc markdown-preview-mode embark-consult embark smartparens dired-rainbow multiple-cursors yaml-mode restclient company-fuzzy projectile yasnippet yasnippets add-node-modules-path flow-minor-mode emmet-mode prettier web-mode editorconfig lsp-ui unicode-fonts dracula-theme dracula magit rg which-key wgrep vertico use-package popup orderless marginalia consult company async))
 '(safe-local-variable-values
   '((eval add-to-list 'lsp-file-watch-ignored-directories "[/\\\\]dist")
     (eval add-to-list 'lsp-file-watch-ignored-directories "[/\\\\]public")
     (eval let
           ((project-directory
             (car
              (dir-locals-find-file default-directory))))
           (setq lsp-clients-typescript-server-args
                 `("--tsserver-path" ,(concat project-directory ".yarn/sdks/typescript/bin/tsserver")
                   "--stdio")))))
 '(warning-suppress-log-types '((jsonrpc)))
 '(warning-suppress-types '((jsonrpc))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
(put 'dired-find-alternate-file 'disabled nil)
