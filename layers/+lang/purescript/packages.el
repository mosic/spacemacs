;;; packages.el --- Purescript Layer packages File for Spacemacs
;;
;; Copyright (c) 2012-2018 Sylvain Benner & Contributors
;;
;; Author: Ryan L. Bell
;; URL: https://github.com/syl20bnr/spacemacs
;;
;; This file is not part of GNU Emacs.
;;
;;; License: GPLv3

(setq purescript-packages
      '(
        add-node-modules-path
        company
        flycheck
        purescript-mode
        psci
        psc-ide
        popwin
        ))

(defun purescript/post-init-add-node-modules-path ()
  (add-hook 'purescript-mode-hook 'add-node-modules-path))

(defun purescript/post-init-company ()
  (when (configuration-layer/package-used-p 'psc-ide)
    (spacemacs|add-company-backends
      :backends company-psc-ide-backend
      :modes purescript-mode)))

(defun purescript/post-init-flycheck ()
  (spacemacs/enable-flycheck 'purescript-mode))

(defun purescript/init-purescript-mode ()
  (use-package purescript-mode
    :defer t
    :init
    (progn
      (add-to-list 'spacemacs-indent-sensitive-modes 'purescript-mode)
      (add-hook 'purescript-mode-hook 'turn-on-purescript-indentation)
      (add-hook 'purescript-mode-hook 'purescript-decl-scan-mode)
      (spacemacs/declare-prefix-for-mode 'purescript-mode "mg" "goto")
      (spacemacs/declare-prefix-for-mode 'purescript-mode "mi" "imports")
      (spacemacs/set-leader-keys-for-major-mode 'purescript-mode
        "i="  'purescript-mode-format-imports
        "i`"  'purescript-navigate-imports-return
        "ia"  'purescript-align-imports
        "in"  'purescript-navigate-imports))))

(defun purescript/init-psci ()
  (use-package psci
    :defer t
    :init
    (progn
      (spacemacs/register-repl 'psci 'psci "purescript")
      (add-hook 'purescript-mode-hook 'inferior-psci-mode)
      (spacemacs/declare-prefix-for-mode 'purescript-mode "ms" "repl")
      (spacemacs/set-leader-keys-for-major-mode 'purescript-mode
        "'"  'psci
        "sb" 'psci/load-current-file!
        "si" 'psci
        "sm" 'psci/load-module!
        "sp" 'psci/load-project-modules!))))

(defun purescript/init-psc-ide ()
  (use-package psc-ide
    :defer t
    :init
    (progn
      (add-hook 'purescript-mode-hook 'psc-ide-mode)

      (customize-set-variable 'psc-ide-add-import-on-completion purescript-add-import-on-completion)
      (customize-set-variable 'psc-ide-rebuild-on-save purescript-enable-rebuild-on-save)

      (add-to-list 'spacemacs-jump-handlers-purescript-mode 'psc-ide-goto-definition)

      (spacemacs/declare-prefix-for-mode 'purescript-mode "mm" "psc-ide")
      (spacemacs/declare-prefix-for-mode 'purescript-mode "mmi" "insert/import")
      (spacemacs/declare-prefix-for-mode 'purescript-mode "mh" "help")
      (spacemacs/set-leader-keys-for-major-mode 'purescript-mode
        "mt"  'psc-ide-add-clause
        "mc"  'psc-ide-case-split
        "ms"  'psc-ide-server-start
        "mb"  'psc-ide-rebuild
        "mq"  'psc-ide-server-quit
        "ml"  'psc-ide-load-all
        "mL"  'psc-ide-load-module
        "mia" 'psc-ide-add-import
        "mis" 'psc-ide-flycheck-insert-suggestion
        "ht"  'psc-ide-show-type))))

(defun purescript/pre-init-popwin ()
  (spacemacs|use-package-add-hook popwin
    :post-config
    (push '("*psc-ide-rebuild*" :tail t :noselect t) popwin:special-display-config)))
