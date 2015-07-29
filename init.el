(setq magit-last-seen-setup-instructions "1.4.0")

(tool-bar-mode 0)
(menu-bar-mode 1)
(setq inhibit-startup-message 1)
(setq initial-scratch-message "")
(column-number-mode 1)
(display-time-mode 1)
(show-paren-mode 1)
(setq ring-bell-function 'ignore)

(setq default-line-spacing 0)
(setq default-fill-column 90)
(setq default-major-mode 'text-mode)
(setq kill-ring-max 200)
(setq require-final-newline t)

(global-font-lock-mode 1)

(transient-mark-mode 1)
(setq scroll-margin 5
      scroll-conservatively 10000)

(show-paren-mode 1)
(setq show-paren-style 'parentheses)
(setq mouse-yank-at-point 1)

(setq visible-bell 0)
(fset 'yes-or-no-p 'y-or-n-p)
(setq resize-mini-windows 0)
(setq enable-recursive-minibuffers 1)

(setq column-number-mode 1)

; file path or buffer name
(setq-default frame-title-format '(buffer-file-name "%f" "%b"))

(setq
   backup-by-copying t      ; don't clobber symlinks
   backup-directory-alist
    '(("." . "~/.saves"))    ; don't litter my fs tree
   delete-old-versions t
   kept-new-versions 6
   kept-old-versions 2
   version-control t)       ; use versioned backups
(setq x-select-enable-clipboard 1)
(setq-default indent-tabs-mode nil)
(setq-default tab-always-indent 0)
(setq-default tab-width 4)
(add-hook 'before-save-hook 'whitespace-cleanup)

;; (global-linum-mode 1)

;;shortcut
(global-set-key (kbd "C-t") 'set-mark-command)
(global-set-key (kbd "M-`") 'next-multiframe-window)
;;font
(prefer-coding-system 'utf-8)
(set-default-font "Menlo 14")
(set-fontset-font "fontset-default" 'unicode "Hiragino Sans GB 14")
;;(load-file "~/.emacs.d/font.el")

;;frame size
(setq default-frame-alist
      '(
        (width . 80) ; character
        (height . 40) ; lines
        ))

;;sys
(add-to-list 'exec-path "/usr/local/bin")

;;Packages
(require 'package)
(add-to-list 'package-archives
             '("melpa" . "http://melpa.org/packages/") t)
(add-to-list 'package-archives
             '("marmalade" . "http://marmalade-repo.org/packages/") t)
(package-initialize)

(when (not package-archive-contents)
  (package-refresh-contents))

;; Add in your own as you wish:
(defvar my-packages '(
                      auto-complete
                      yasnippet
                      smex
                      js2-mode
                      js2-refactor
                      discover
                      discover-js2-refactor
                      emmet-mode
                      less-css-mode
                      flx-ido
                      flx
                      bookmark+
                      base16-theme
                      multiple-cursors
                      web-mode
                      magit
                      recentf-ext
                      ido-vertical-mode
                      kill-ring-ido
                      hungry-delete
                      powerline
                      zoom-frm
                      subatomic-theme
                      undo-tree
                      )
  "A list of packages to ensure are installed at launch.")

(dolist (p my-packages)
  (when (not (package-installed-p p))
    (package-install p)))

(require 'undo-tree)
(global-undo-tree-mode 1)
(global-set-key (kbd "C-?") 'undo-tree-redo)

(require 'recentf)
(recentf-mode 1)
(global-set-key "\C-xf" 'recentf-open-files)
(setq recentf-auto-cleanup 'never)
(require 'recentf-ext)

(require 'auto-complete)
(require 'auto-complete-config)
(ac-config-default)
(add-to-list 'ac-modes 'less-css-mode)
(add-hook 'less-css-mode-hook 'ac-css-mode-setup)

;; (require 'company)
;; (add-hook 'after-init-hook 'global-company-mode)

(require 'yasnippet)
(yas-global-mode 1)

(setq-default ac-sources '(
                           ac-source-yasnippet
                           ac-source-abbrev
                           ac-source-dictionary
                           ac-source-words-in-same-mode-buffers
                           ))

(require 'ibuffer)
(global-set-key ( kbd "C-x C-b ")' ibuffer)
(add-hook 'ibuffer-mode-hook
          '(lambda()
             (ibuffer-auto-mode 1)))
(setq ibuffer-expert 1)

(require 'ido)
(ido-mode t)
(require 'ido-vertical-mode)
(ido-vertical-mode 1)

(require 'flx-ido)
(flx-ido-mode 1)
(setq ido-use-faces nil)

(require 'smex)
(smex-initialize)
(global-set-key (kbd "M-x") 'smex)
(global-set-key (kbd "M-X") 'smex-major-mode-commands)

(require 'js2-mode)
(add-to-list 'ac-modes 'js2-mode)
(setq js2-highlight-level 3)
(setq-default js2-auto-indent-p 1)
(setq-default js2-enter-indents-newline 1)
(setq-default js2-indent-level 4)
(setq-default js2-consistent-level-indent-inner-bracket 1)
(setq-default js2-global-externs '(
                              "console"
                              "define"
                              "require"
                              "module"
                              "global"
                              "process"
                              "$"
                              ))
(add-to-list 'auto-mode-alist '("\\.js\\'" . js2-mode))

(require 'js2-refactor)
(add-hook 'js2-mode-hook #'js2-refactor-mode)
(js2r-add-keybindings-with-prefix "C-c C-,")
(require 'discover-js2-refactor)

;; web dev
(require 'emmet-mode)
(add-hook 'sgml-mode-hook 'emmet-mode)
(add-hook 'css-mode-hook  'emmet-mode)
(add-hook 'emmet-mode-hook (lambda () (setq emmet-indentation 4)))
(setq emmet-move-cursor-between-quotes t)

;; for web mode
(add-to-list 'auto-mode-alist '("\\.hbs\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.ejs\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.tpl\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.html?\\'" . web-mode))
(defun my-web-mode-hook ()
  "Hooks for Web mode."
  (setq web-mode-markup-indent-offset 4)
  (setq web-mode-css-indent-offset 4)
  (setq web-mode-code-indent-offset 4)
)
(add-hook 'web-mode-hook  'my-web-mode-hook)
(add-hook 'web-mode-hook 'emmet-mode)

(setq sgml-basic-offset 4)

(require 'indent-guide)
(indent-guide-global-mode)

(require 'bookmark+)

(require 'multiple-cursors)
(global-set-key (kbd "C->") 'mc/mark-next-like-this)
(global-set-key (kbd "C-<") 'mc/mark-previous-like-this)
(global-set-key (kbd "C-c C-<") 'mc/mark-all-like-this)
(global-unset-key (kbd "M-<down-mouse-1>"))
(global-set-key (kbd "M-<mouse-1>") 'mc/add-cursor-on-click)

(require 'popwin)
(popwin-mode 1)

;; hs minor mode
(add-hook 'js2-mode-hook (lambda()
                      (imenu-add-menubar-index)
                      (hs-minor-mode t)))

(load-theme 'subatomic t)

(require 'kill-ring-ido)
(global-set-key (kbd "M-y") 'kill-ring-ido)
(setq kill-ring-ido-shortage-length 18)

(require 'magit)
(set-variable 'magit-emacsclient-executable "/Applications/Emacs.app/Contents/MacOS/bin/emacsclient")
(setq magit-git-executable "/usr/local/bin/git")
(require 'magit-gitflow)
(add-hook 'magit-mode-hook 'turn-on-magit-gitflow)
(setq-default magit-push-always-verify nil)

(require 'zoom-frm)
(global-set-key (kbd "C-x C-=") 'zoom-in)
(global-set-key (kbd "C-x C--") 'zoom-out)

(projectile-global-mode)

;; exit confirm
(defun ask-before-closing ()
  "Ask whether or not to close, and then close if y was pressed"
  (interactive)
  (if (y-or-n-p (format "Are you sure you want to exit Emacs? "))
      (if (< emacs-major-version 22)
          (save-buffers-kill-terminal)
        (save-buffers-kill-emacs))
    (message "Canceled exit")))

(when window-system
  (global-set-key (kbd "C-x C-c") 'ask-before-closing))

(load-file "~/.emacs.d/heel.el")
(load-file "~/.emacs.d/hydra.el")
(load-file "~/.emacs.d/myjira.el")

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(bmkp-last-as-first-bookmark-file "~/.emacs.d/bookmarks")
 '(column-number-mode 1)
 '(confluence-default-space-alist (list (cons confluence-url "f2e")))
 '(confluence-url "http://confluence.datayes.com/rpc/xmlrpc")
 '(custom-safe-themes
   (quote
    ("726dd9a188747664fbbff1cd9ab3c29a3f690a7b861f6e6a1c64462b64b306de" "40bc0ac47a9bd5b8db7304f8ef628d71e2798135935eb450483db0dbbfff8b11" "603a9c7f3ca3253cb68584cb26c408afcf4e674d7db86badcfe649dd3c538656" "9122dfb203945f6e84b0de66d11a97de6c9edf28b3b5db772472e4beccc6b3c5" "18a33cdb764e4baf99b23dcd5abdbf1249670d412c6d3a8092ae1a7b211613d5" "f9e975bdf5843982f4860b39b2409d7fa66afab3deb2616c41a403d788749628" default)))
 '(display-time-mode t)
 '(face-font-family-alternatives
   (quote
    (("arial black" "arial" "DejaVu Sans")
     ("arial" "DejaVu Sans")
     ("verdana" "DejaVu Sans"))))
 '(font-lock-keywords-case-fold-search t t)
 '(global-font-lock-mode t nil (font-lock))
 '(ibuffer-saved-filter-groups
   (quote
    (("mercury"
      ("data"
       (filename . "\\/data\\/"))
      ("notebook"
       (filename . "notebook")))
     ("datayes"
      ("mercury"
       (filename . "mercury"))
      ("cr"
       (filename . "/cr/"))
      ("achy"
       (filename . "achy"))
      ("yestrap"
       (filename . "yestrap"))
      ("docs"
       (filename . "doc"))
      ("heel"
       (filename . "heel"))))))
 '(ibuffer-saved-filters
   (quote
    (("gnus"
      ((or
        (mode . message-mode)
        (mode . mail-mode)
        (mode . gnus-group-mode)
        (mode . gnus-summary-mode)
        (mode . gnus-article-mode))))
     ("programming"
      ((or
        (mode . emacs-lisp-mode)
        (mode . cperl-mode)
        (mode . c-mode)
        (mode . java-mode)
        (mode . idl-mode)
        (mode . lisp-mode)))))))
 '(js2-include-browser-externs t)
 '(js2-include-node-externs t)
 '(package-selected-packages
   (quote
    (discover-js2-refactor undo-tree handlebars-sgml-mode swiper hydra zoom-frm web-mode w3m w3 subatomic-theme sos smex recentf-ext powerline popwin noflet nginx-mode mustache-mode markdown-mode magit-gitflow lua-mode less-css-mode kill-ring-ido keyfreq jsx-mode json-mode js3-mode indent-guide ido-vertical-mode hungry-delete hackernews go-eldoc flx-ido emmet-mode company browse-kill-ring bookmark+ base16-theme auto-complete anaphora amd-mode ag)))
 '(show-paren-mode t)
 '(show-trailing-whitespace t)
 '(sr-speedbar-auto-refresh nil)
 '(tool-bar-mode nil))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(mode-line ((t (:background "#141414" :foreground "#828282" :box nil :height 120)))))
