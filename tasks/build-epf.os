#Использовать logos
#Использовать v8runner
#Использовать tempfiles

Перем КаталогПроекта;
Перем Лог;

Процедура ПолезнаяРабота()

	КаталогОбработок = ОбъединитьПути(КаталогПроекта, "epf");
	КаталогBin = ОбъединитьПути(КаталогПроекта, "bin");
	КаталогСборки = ВременныеФайлы.СоздатьКаталог();

	КаталогиОбработок = НайтиФайлы(КаталогОбработок, ПолучитьМаскуВсеФайлы());

	УправлениеКонфигуратором = Новый УправлениеКонфигуратором;

	УправлениеКонфигуратором.КаталогСборки(КаталогСборки);
	Для каждого КаталогОбработки Из КаталогиОбработок Цикл
		
		Если КаталогОбработки.ЭтоФайл() Тогда
			Продолжить;
		КонецЕсли;

		МассивФайлов = НайтиФайлы(КаталогОбработки.ПолноеИмя, "*.xml");

		Если МассивФайлов.Количество() = 0 Тогда
			Продолжить;
		КонецЕсли;

		ФайлОписанияОбработки = МассивФайлов[0];
		ПутьКФайлуОбработки = ОбъединитьПути(КаталогBin, ФайлОписанияОбработки.ИмяБезРасширения + ".epf");

		Лог.Информация("Собираю обработку <%1> из исходников в файл %2", ФайлОписанияОбработки.ИмяБезРасширения, ПутьКФайлуОбработки);
		СобратьОбработку(УправлениеКонфигуратором, ФайлОписанияОбработки.ПолноеИмя, ПутьКФайлуОбработки);

	КонецЦикла;

	ВременныеФайлы.Удалить();

КонецПроцедуры

Процедура СобратьОбработку(УправлениеКонфигуратором, Знач ПутьКФайлу, Знач ПутьКФайлуОбработки)
	
    Параметры = УправлениеКонфигуратором.ПолучитьПараметрыЗапуска();
	
    Параметры.Добавить("/LoadExternalDataProcessorOrReportFromFiles");
    Параметры.Добавить(СтрШаблон("""%1""", ПутьКФайлу));
    Параметры.Добавить(СтрШаблон("""%1""", ПутьКФайлуОбработки));

	УправлениеКонфигуратором.ВыполнитьКоманду(Параметры);
    Лог.Отладка("Вывод 1С:Предприятия - " + УправлениеКонфигуратором.ВыводКоманды());

КонецПроцедуры


КаталогПроекта = ОбъединитьПути(ТекущийСценарий().Каталог, "..");

Лог = Логирование.ПолучитьЛог("oscript.tasks");

ПолезнаяРабота();