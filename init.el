(add-to-list 'load-path (expand-file-name "lisp" user-emacs-directory))

(setq url-proxy-services
      '(("http"     . "127.0.0.1:1080")
        ("https"    . "127.0.0.1:1080")
        ("no_proxy" . "^\\(localhost\\|10.*\\)")))

(require 'bind-key)
(global-set-key (kbd "C-t") 'set-mark-command)
(bind-key* (kbd "M-<tab>") 'other-window)
(global-set-key (kbd "C-x C-k") 'kill-current-buffer)
(global-set-key (kbd "C-x C-b") 'ibuffer-other-window)
(global-unset-key (kbd "C-SPC"))

;; config
(setq-default make-backup-files nil)
(setq-default indent-tabs-mode t)
(setq tab-width 2)
(setq kill-whole-line t)
(fset 'yes-or-no-p 'y-or-n-p)
(setq electric-indent-inhibit t)
(setq dired-listing-switches "-aBhl --group-directories-first")
(setq vc-follow-symlinks t)
(global-auto-revert-mode 1)

;; move lock files like .#abc.js to tmp
(setq lock-file-name-transforms
      '(("\\`/.*/\\([^/]+\\)\\'" "/var/tmp/\\1" t)))

(setq auto-save-file-name-transforms
      `((".*" "~/.emacs.d/auto-saves/" t)))

(require 'init-ibuffer)

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

(when (daemonp)
  (setq use-package-always-demand t))

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
  (setq projectile-project-search-path '("~/src/" "~/work/" ("~/github" . 1))))

(use-package ibuffer-vc
  :config
  (add-hook 'ibuffer-hook
            (lambda ()
              (ibuffer-vc-set-filter-groups-by-vc-root)
              (unless (eq ibuffer-sorting-mode 'alphabetic)
                (ibuffer-do-sort-by-alphabetic)))))

;; editorconfig
;; (use-package editorconfig
;;   :config
;;   (editorconfig-mode 1))

(use-package dtrt-indent)

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
  (recentf-mode)
  :bind ("C-x f" . recentf))

(use-package yasnippet
  :config
  (yas-global-mode))

(use-package yasnippet-snippets)

(use-package exec-path-from-shell
  :ensure t
  :config
  (setq exec-path-from-shell-debug t)
  :custom
  (exec-path-from-shell-arguments '("-l" "-i"))
  (exec-path-from-shell-shell-name "/usr/bin/fish")
  (exec-path-from-shell-variables '("PATH" "FNM_MULTISHELL_PATH"))
  :init
  (exec-path-from-shell-initialize)
  (when (daemonp)
  (exec-path-from-shell-initialize)))

(use-package add-node-modules-path
  :ensure t
  :custom
  (add-node-modules-path-command '("pnpm bin")))

;; Map extensions to the Tree-sitter modes
(add-to-list 'auto-mode-alist '("\\.css\\'" . css-ts-mode))
(add-to-list 'auto-mode-alist '("\\.json\\'" . json-ts-mode))
(add-to-list 'auto-mode-alist '("\\.json5\\'" . json5-ts-mode))
(add-to-list 'auto-mode-alist '("\\.js\\'" . js-ts-mode))
(add-to-list 'auto-mode-alist '("\\.ts\\'" . typescript-ts-mode))
(add-to-list 'auto-mode-alist '("\\.tsx\\'" . tsx-ts-mode))
(add-to-list 'auto-mode-alist '("\\.yaml\\'" . yaml-ts-mode))
(add-to-list 'auto-mode-alist '("\\.html\\'" . html-ts-mode))

(require 'treesit)
(add-to-list 'treesit-language-source-alist
             '(json5 "https://github.com/Joakker/tree-sitter-json5"))

(use-package treesit-auto
  :custom
  (treesit-auto-install 'prompt)
  :config
  (treesit-auto-add-to-auto-mode-alist 'all)
  (global-treesit-auto-mode))

(progn
  (defun my/add-node-path-hook ()
    (add-node-modules-path)
    (eglot-ensure))

  (add-hook 'typescript-ts-mode-hook #'my/add-node-path-hook)
  (add-hook 'tsx-ts-mode-hook #'my/add-node-path-hook)
  (add-hook 'css-ts-mode-hook #'my/add-node-path-hook)
  (add-hook 'js-ts-mode-hook #'my/add-node-path-hook)
  (add-hook 'json5-ts-mode-hook #'my/add-node-path-hook)
  (add-hook 'json-ts-mode-hook #'my/add-node-path-hook)
  (add-hook 'yaml-ts-mode-hook #'my/add-node-path-hook))

(use-package eglot
  ;; :config
  ;; (add-to-list 'eglot-server-programs
  ;;              '((js-mode tsx-ts-mode typescript-ts-mode) .
  ;;                ("rass" "--"
  ;;                 "pnpm" "typescript-language-server" "--stdio" "--"
  ;;                 "pnpm" "oxlint" "--lsp")))
  :bind (
	 ("C-." . eglot-code-actions)))

(with-eval-after-load 'eglot
  (setq completion-category-defaults nil))

(setq completion-styles '(basic substring partial-completion flex)
      read-file-name-completion-ignore-case t
      read-buffer-completion-ignore-case t
      completion-ignore-case t)

(use-package reformatter
  :config
  ;; Define the formatter
  (reformatter-define oxfmt
    :program "oxfmt"
    :args (list "--stdin-filepath" (buffer-file-name) "-")
    :lighter " Oxfmt")

  ;; Enable it automatically for specific modes
  (add-hook 'css-ts-mode-hook #'oxfmt-on-save-mode)
  (add-hook 'typescript-ts-mode-hook #'oxfmt-on-save-mode)
  (add-hook 'js-ts-mode-hook #'oxfmt-on-save-mode)
  (add-hook 'json-ts-mode-hook #'oxfmt-on-save-mode)
  (add-hook 'tsx-ts-mode-hook #'oxfmt-on-save-mode)
  (add-hook 'yaml-ts-mode-hook #'oxfmt-on-save-mode))


(use-package corfu
  :custom
  (corfu-cycle t)
  (corfu-auto t)
  (corfu-preview-current nil)
  :init
  (global-corfu-mode))

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
	 ("M-y" . consult-yank-pop)
         ("C-M-g" . consult-yank-pop))
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

(use-package keychain-environment
  :ensure t
  :config
  (keychain-refresh-environment))

;; magit
(use-package magit
  :ensure t
  :bind (
         :map magit-file-section-map ("RET" . magit-diff-visit-file-other-window)
         :map magit-hunk-section-map ("RET" . magit-diff-visit-file-other-window)))

;; local package
(require 'magit-filenotify)
(add-hook 'magit-status-mode-hook 'magit-filenotify-mode)

(use-package diff-hl
  :init
  (global-diff-hl-mode))

;; dracula theme
(use-package dracula-theme
  :init
  ;;(load-theme 'dracula t)
  )

;; local package
(require 'alucard-theme)
(load-theme 'alucard t)

;; mode line
(use-package doom-modeline
  :init
  (doom-modeline-mode 1))

(setq doom-modeline-height 1)
(setq all-the-icons-scale-factor 1)
(setq doom-modeline-icon nil)
(set-face-attribute 'mode-line nil :family "JetBrains Mono" :height 120)
(set-face-attribute 'mode-line-inactive nil :family "JetBrains Mono" :height 120)

(use-package emmet-mode
  :hook (
         (web-mode . emmet-mode)
         (css-mode . emmet-mode)
         (scss-mode . emmet-mode)
         (tsx-ts-mode . emmet-mode))
  :config
        (add-to-list 'emmet-jsx-major-modes 'tsx-ts-mode))

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
  (setq markdown-preview-stylesheets (list "https://cdnjs.cloudflare.com/ajax/libs/github-markdown-css/5.9.0/github-markdown-light.min.css")))

(use-package dotenv-mode
  :mode (("\\.env" . dotenv-mode)))

(use-package dirvish
  :init
  (dirvish-override-dired-mode))

(use-package treemacs
  :ensure t
  :defer t
  :config
  (setq treemacs-indentation 1) ; 2 spaces, 10 pixels wide
  (setq treemacs-move-files-by-mouse-dragging nil) ; disable dragging
  :bind
  ("C-c t" . treemacs-select-window))

(use-package treemacs-projectile
  :after (treemacs projectile)
  :ensure t)

(use-package treemacs-icons-dired
  :hook (dired-mode . treemacs-icons-dired-enable-once)
  :ensure t)

(use-package treemacs-magit
  :after (treemacs magit)
  :ensure t)

(treemacs-start-on-boot)

(use-package ace-window
  :ensure
  :config (setq aw-dispatch-always t)
  :bind ("M-o" . ace-window))

(use-package golden-ratio
  :init (golden-ratio-mode 1)
  :config (setq golden-ratio-auto-scale t
                golden-ratio-adjust-factor .8
                golden-ratio-wide-adjust-factor .8))

(defun my/set-fonts ()
  (interactive)
  (setq use-default-font-for-symbols nil)
  (set-face-attribute 'default nil :family "JetBrains Mono" :height 150)
  (set-fontset-font t 'han (font-spec :family "Noto Sans CJK SC" :height 150) nil 'append)
  (setq face-font-rescale-alist '(("Noto Sans CJK SC" . 0.93)))
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
   ["#2e3436" "#a40000" "#4e9a06" "#c4a000" "#204a87" "#5c3566" "#729fcf"
    "#eeeeec"])
 '(custom-safe-themes
   '("0223215a464167d93b9cfef9b1cdf9b0768ab660f33b3068b647f7b12aa453a0"
     "5202a104dd97337ced9e7350725ba28fb700f640f619ca2e130203994be91af0"
     "84749a6b10cdc36cec5014f3210ba0b01d988c7a44f058796be42499164ae6a0"
     "bcc103f8e03496d689a1c2d6166b3031f3893cdf13d571ef4463b68ecc393c8e"
     default))
 '(dtrt-indent-global-mode t)
 '(dtrt-indent-verbosity 3)
 '(package-selected-packages
   '(add-node-modules-path alucard-theme cape corfu diff-hl dirvish
                           doom-modeline dotenv-mode dracula-theme
                           dtrt-indent embark-consult emmet-mode
                           exec-path-from-shell fish-mode golden-ratio
                           ibuffer-vc json5-ts-mode
                           keychain-environment magit-filenotify
                           marginalia markdown-preview-mode
                           multiple-cursors reformatter rg smartparens
                           systemd treemacs-icons-dired treemacs-magit
                           treemacs-projectile treesit-auto vertico
                           yaml-mode yasnippet-snippets))
 '(tab-width 2))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
